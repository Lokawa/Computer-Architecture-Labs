`timescale 1ns / 1ps

module instrDecode(
    input clk,
    input reset,
    input [31:0] buf1_PC,
    input [31:0] buf1_IR,
    //buffer 1
    input possibleStall,
    input [4:0] stallAddr,
    input possibleForward1,
    input [4:0] forwardAddr1,
    input [31:0] forwardData1,
    input possibleForward2,
    input [4:0] forwardAddr2,
    input [31:0] forwardData2,
    //forwarding
    //***请补充***寄存器堆在Instruction Decode 阶段接受writeback数据写回的三个信号。
    input L_regWrite,
    input [4:0] L_writeReg,
    input [31:0] L_writeData,
    
    input [31:0] fetch_PC,
    //prediction buffer
    output reg buf2_ALUsrc,
    output reg buf2_MemToReg,
    output reg buf2_regWrite,
    output reg buf2_memRead,
    output reg buf2_memWrite,
    output reg buf2_Extop,
    output reg [2:0] buf2_ALUop,
    output reg [31:0] buf2_A,
    output reg [31:0] buf2_B,
    output reg [31:0] buf2_IR,
    output reg [4:0] buf2_writeAddr,
    output wrongPrediction,
    output [31:0] wrongPC,
    output [31:0] nextPC,
    output setPC,
    output stall
);
    wire regDst;
    wire ALUsrc;
    wire MemToReg;
    wire regWrite;
    wire memRead;
    wire memWrite;
    wire Extop;
    wire Branch;
    wire [2:0] ALUop;
    wire Jump;
    wire call;
    Ctr CU(
        .clk(clk),
        .reset(reset),
        .opCode(buf1_IR[31:26]),
        .regDst(regDst),
        .ALUsrc(ALUsrc),
        .MemToReg(MemToReg),
        .regWrite(regWrite),
        .memRead(memRead),
        .memWrite(memWrite),
        .Extop(Extop),
        .Branch(Branch),
        .ALUop(ALUop),
        .Jump(Jump),
        .call(call)
    );
    
    reg [31:0] ID_PC;
    reg [31:0] ID_IR;
    wire [4:0] writeAddr;
    wire [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;
    //MUX for writeAddr
    assign writeAddr = (regDst) ? (buf1_IR[15:11]) : (buf1_IR[20:16]);
    Registers RF(
        .clk(clk),
        .reset(reset), //reset
        .readReg1(buf1_IR[25:21]),
        .readReg2(buf1_IR[20:16]),
        .writeReg(L_writeReg),
        .writeData(L_writeData),
        .regWrite(L_regWrite),
        .readData1(readData1),
        .readData2(readData2),
        .call(call),
        .curPC(ID_PC)
    );
    reg [31:0] ID_fetch_PC;
    always @(posedge clk)
    begin
        ID_fetch_PC <= fetch_PC;
        ID_PC <= buf1_PC;
        ID_IR <= buf1_IR;
    end
    wire alias11;
    wire alias12;
    wire alias21;
    wire alias22;
    wire [31:0] conditional_A;
    wire [31:0] conditional_B;
    assign alias11 = (possibleForward1) && (forwardAddr1==ID_IR[25:21]);
    assign alias21 = (possibleForward1) && (forwardAddr1==ID_IR[20:16]);
    assign alias12 = (possibleForward2) && (!alias11) && (forwardAddr2==ID_IR[25:21]);
    assign alias22 = (possibleForward2) && (!alias21) && (forwardAddr2==ID_IR[20:16]);
    assign conditional_A = (alias11) ? (forwardData1) :((alias12) ? (forwardData2) : (readData1));
    assign conditional_B = (alias21) ? (forwardData1) :((alias22) ? (forwardData2) : (readData2));
    always @(negedge clk)
    begin
        if(stall)
        begin
        //***请补充:出现stall时，如果向下传递nop指令。也就是对buf2_ALUsrc，buf2_MemToReg，buf2_regWrite，buf2_memRead，buf2_memWrite，
        //buf2_Extop，buf2_ALUop，buf2_IR，buf2_writeAddr，buf2_A，buf2_B 进行赋值。
           buf2_ALUsrc<=ALUsrc;
           buf2_MemToReg<=0;
           buf2_regWrite<=0;
           buf2_memRead<=memRead;
           buf2_memWrite<=memWrite;
           buf2_Extop<=Extop;
           buf2_ALUop<=ALUop;
           buf2_IR<=buf1_IR;
           buf2_writeAddr<=writeAddr;
           buf2_A<=conditional_A;
           buf2_B<=conditional_B;
        end
        else
        begin
        buf2_ALUsrc<=ALUsrc;
        buf2_MemToReg<=MemToReg;
        buf2_regWrite<=regWrite;
        buf2_memRead<=memRead;
        buf2_memWrite<=memWrite;
        buf2_Extop<=Extop;
        buf2_ALUop<=ALUop;
        buf2_IR<=ID_IR;
        buf2_writeAddr<=writeAddr;
        buf2_A <= conditional_A;
        buf2_B <= conditional_B;
        end
    end
    
    wire [31:0] imm;
    Ext Ext0(
        .Extop(Extop),
        .inst(ID_IR[15:0]),
        .data(imm)
    );
    wire [31:0] offset;
    assign offset = imm << 2;
    wire PCsrc;
    and A0(PCsrc,Branch,(conditional_A==conditional_B));
    wire ret;
    and A1(ret,(ID_IR[31:26]==6'b000000),(ID_IR[5:0]==6'b001000));
    PCupdate PCup(
        .newPC(ID_PC),
        .PCsrc(PCsrc),
        .offset(offset),
        .ret(ret),
        .retAddr(conditional_A),
        .nextPC(nextPC)
    );
    and A2(setPC,(ID_fetch_PC != nextPC),(!Jump));
    and A3(wrongPrediction,setPC,PCsrc);
    assign wrongPC = ID_PC - 4;
    
    assign stall = (!Jump) && (!ret) && (possibleStall) && ((stallAddr==ID_IR[25:21])||((stallAddr==ID_IR[20:16]) && ((ID_IR[31:26]==6'b000000)||(ID_IR[31:26]==6'b101011)||(ID_IR[31:27]==5'b00010))));
    
endmodule
