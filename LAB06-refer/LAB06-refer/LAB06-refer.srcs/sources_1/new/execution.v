`timescale 1ns / 1ps


module execution(
    input clk,
    input reset,
    input buf2_Extop,
    input [31:0] buf2_IR,
    input [2:0] buf2_ALUop,
    input buf2_ALUsrc,
    input [31:0] buf2_A,
    input [31:0] buf2_B,
    input buf2_MemToReg,
    input buf2_regWrite,
    input buf2_memRead,
    input buf2_memWrite,
    input [4:0] buf2_writeAddr,
    output reg buf3_MemToReg,
    output reg buf3_regWrite,
    output reg [4:0] buf3_writeAddr,
    output reg [31:0] buf3_ALUres,
    output reg [31:0] buf3_writeData,
    output reg buf3_memRead,
    output reg buf3_memWrite,
    output reg possibleStall,
    output [4:0] stallAddr,
    output reg possibleForward1,
    output [4:0] forwardAddr1,
    output [31:0] forwardData1
    );
    
    wire [31:0] ALUdata2;
    Ext Ext0(
        .Extop(buf2_Extop),
        .inst(buf2_IR[15:0]),
        .data(ALUdata2)
    );
    wire [3:0] ALUctrOut;
    ALUctr ALUCU(
        .ALUop(buf2_ALUop),
        .Funct(buf2_IR[5:0]),
        .ALUctrOut(ALUctrOut)
    );
    wire [31:0] ALUinput2;
    assign ALUinput2 = (buf2_ALUsrc) ? (ALUdata2) : (buf2_B);
    //We need then do with the ALU input, and deal with ALU itself afterwards. 
    wire zero;
    wire [31:0] ALUres;
    wire ret;    //control the PC, let it return $rs or not.
    ALU ALU0(
        .clk(clk),
        .input1(buf2_A),
        .input2(ALUinput2),
        .shift(buf2_IR[10:6]),
        .ALUctrOut(ALUctrOut),
        .ALUres(ALUres),
        .zero(zero),    //zero = 1, if ALUres == 0.
        .ret(ret)
    );
    reg [31:0] EX_B;
    reg EX_memRead;
    reg EX_memWrite;
    reg EX_MemToReg;
    reg EX_regWrite;
    reg [4:0] EX_writeAddr;
    always @(posedge clk)
    begin
        EX_B <= buf2_B;
        EX_writeAddr <= buf2_writeAddr;
        if(reset)
        begin
            EX_MemToReg <= 0;
            EX_regWrite <=0;
            EX_memRead <= 0;
            EX_memWrite <= 0;
            possibleStall <= 0;
            possibleForward1 <= 0;
        end
        else
        begin
            EX_MemToReg <= buf2_MemToReg;
            EX_regWrite <= buf2_regWrite;
            EX_memRead <= buf2_memRead;
            EX_memWrite <= buf2_memWrite;
            possibleStall <= (buf2_MemToReg)&&(buf2_regWrite);
            possibleForward1 <= (!buf2_MemToReg)&&(buf2_regWrite);
        end
    end
    //***请补充*** EX阶段检测数据冒险需要传回到ID阶段数据和寄存器号；
    assign forwardAddr1 = EX_writeAddr;//
    assign forwardData1=  ALUres;//
    assign stallAddr = EX_writeAddr;//
    always @(negedge clk)
    begin
        buf3_MemToReg<=EX_MemToReg;
        buf3_regWrite<=EX_regWrite;
        buf3_writeAddr<=EX_writeAddr;
        buf3_ALUres<=ALUres;
        buf3_writeData<=EX_B;
        buf3_memRead<=EX_memRead;
        buf3_memWrite<=EX_memWrite;
    end
endmodule
