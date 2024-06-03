`timescale 1ns / 1ps

module TOP(
   // input reset,
 //   input clk,
    input clk_p,
    input clk_n,
    input [3:0] a,
    input [3:0] b,
    input _reset,
    output led_clk,
    output led_do,
    output led_en,
    output wire seg_clk,
    output wire seg_en,
    output wire seg_do
    );
    //IF
    //reg [31:0] PCreg;
    wire [31:0] PCreg;
    wire [31:0] newPC;
    wire [31:0] instr;
    //Control Signal
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
    
    wire CLK_i;
    wire Clk_25M;
    IBUFGDS IBUFGDS_inst(
        .O(CLK_i),
        .I(clk_p),
        .IB(clk_n));
    
    reg [1:0] clkdiv;
    always @(posedge CLK_i)
        clkdiv<=clkdiv+1;
    assign Clk_25M=clkdiv[1];
    wire [7:0] result;
    wire [3:0] a;
    wire [3:0] b;
    assign result=a*b;
   // assign result=8'b01110101;
    display DISPLAY(
        .clk(Clk_25M),
        .rst(1'b0),
        .en(8'b00001111),
        .data({24'b0,result}),
        .dot(8'b00000000),
        .led(~{8'b0,result}),
        .led_clk(led_clk),
        .led_en(led_en),
        .led_do(led_do),
        .seg_clk(seg_clk),
        .seg_en(seg_en),
        .seg_do(seg_do)
        );
        
    wire clk;
    wire reset;
    assign reset=!_reset;
    assign clk=Clk_25M;    
    
   // always @ (posedge clk)
  ///  begin
    //    if (reset)
    //        PCreg = 0;
    //end
    
    PC PCadd4(  
        .PC(PCreg),
        .reset(reset),
        .clk(clk),
        .newPC(newPC)
    );
    
    instrMem IF(
        .readAddr(PCreg),
        .clk(clk),
        .reset(reset),
        .instr(instr)
    );
    Ctr CU(
        .opCode(instr[31:26]),
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
    
    wire [4:0] writeAddr;
    wire [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;
    
    //针对 jal 指令的新增 writeaddress的 MUX
    assign writeAddr=(ALUsrc)? instr[20:16]:((call==0)?instr[15:11]:5'b11111);
    
    Registers RF(
        .clk(clk),
        .reset(reset), //reset
        .readReg1(instr[25:21]),
        .readReg2(instr[20:16]),
        .writeReg(writeAddr),
        .writeData(writeData),
        .regWrite(regWrite),
        .readData1(readData1),
        .readData2(readData2)
    );
    
    wire [31:0] ALUdata2;
    Ext Ext0(
        .Extop(Extop),
        .inst(instr[15:0]),
        .data(ALUdata2)
    );
    
    wire [3:0] ALUctrOut;
    ALUctr ALUCU(
        .ALUop(ALUop),
        .Funct(instr[5:0]),
        .ALUctrOut(ALUctrOut)
    );
    
    wire [31:0] ALUinput2;
    
    assign ALUinput2 = (ALUsrc) ? (ALUdata2) : (readData2);
   
    //We need then do with the ALU input, and deal with ALU itself afterwards. 
    wire zero;
    wire [31:0] ALUres;
    wire ret;    //control the PC, let it return $rs or not.
    ALU ALU0(
        .input1(readData1),
        .input2(ALUinput2),
        .shift(instr[10:6]),
        .ALUctrOut(ALUctrOut),
        .ALUres(ALUres),
        .zero(zero),    //zero = 1, if ALUres == 0.
        .ret(ret)
    );
    
    //update PC for beq and j instruction.
    wire PCsrc;
    and A0(PCsrc,Branch,zero);
    wire [31:0] offset;
    assign offset = ALUdata2 << 2;
    wire [31:0] nextPC;
    
    PCupdate PCup(
        .newPC(newPC),
        .PCsrc(PCsrc),
        .offset(offset),
        .target(instr[25:0]),
        .Jump(Jump),
        .ret(ret),
        .retAddr(ALUres),
        .nextPC(PCreg)
    );
    
    //always @ (negedge clk)
   // begin
  //     PCreg = nextPC;
  //  end
    
    wire [31:0] memOut;
    // memory operation for sw and lw.
    DataMemory DMEM(
        .clk(clk),
        .addr(ALUres),
        .writeData(readData2),
        .memWrite(memWrite),
        .memRead(memRead),
        .readData(memOut)
    );
    
    //针对 jal 指令的新增 writedata的 MUX
    assign writeData = (call) ?newPC : ((ALUsrc)?memOut:ALUres);
    
endmodule
