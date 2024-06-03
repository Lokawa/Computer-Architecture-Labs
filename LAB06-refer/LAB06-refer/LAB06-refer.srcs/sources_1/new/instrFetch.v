`timescale 1ns / 1ps

module instrFetch(
    input clk,
    input reset,
    input [31:0] nextPC,
    input setPC,
    input wrongPrediction,
    input [31:0] wrongPC,
    input stall,
    output reg [31:0] fetch_PC,
    output reg [31:0] buf1_PC,//***请补充***：定义两个Pipeline register 的输出， buf1_PC储存PC 和buf1_IR 存储取出的指令
    output reg [31:0] buf1_IR 
    );
    reg [15:0] branchTable;  //Hashed branch History Table!
    reg [31:0] PCreg;
    wire [31:0] newPC;
    wire [31:0] instr;
    always @ (posedge clk)
    begin
        if (reset)
        begin
            PCreg <= 0;
            branchTable <= 0;
        end
    end
    PC PCadd4(  //posedge
        .PC(PCreg),
        .reset(reset),
        .clk(clk),
        .newPC(newPC)
    );
    instrMem IF(  //posedge
        .readAddr(PCreg),
        .clk(clk),
        .reset(reset),
        .instr(instr)
    );
    wire PCsrc;
    and A0(PCsrc,branchTable[PCreg[5:2]],(instr[31:26]==6'b000100));  //Prediction
    wire [31:0] fetch_target;
    wire [27:0] shtarget;
    assign shtarget = instr[25:0] << 2;
    wire [31:0] jumptarget;
    assign jumptarget = {newPC[31:28],shtarget};
    wire [31:0] offset;
    assign offset = ({{16{instr[15]}},instr[15:0]} << 2);
    wire [31:0] branchtarget;
    assign branchtarget = newPC + offset;
    wire [31:0] nonjumptarget;
    assign nonjumptarget = (PCsrc) ? (branchtarget) : (newPC);
    assign fetch_target = (instr[31:27]==5'b00001) ? (jumptarget) : (nonjumptarget);//jump instruction!
    always @(negedge clk)
    begin
    if(!stall) //if stalled do nothing, the sematics remain unchanged!
    begin
         //***请补充**在下降沿更新stall时，！stall 时应如何跟新buf1_PC
        //update PC, there must be a bubble!
        buf1_PC=fetch_target;
        if(setPC)
        begin
            //ret or wrong prediction!
            //***请添加***ret or wrong prediction 情况出现的处理情况代码
           
           fetch_PC<=buf1_PC;
           PCreg<=buf1_PC;
           
           
           
        end
        else
        begin
            buf1_IR <= instr;
            PCreg <= fetch_target;
            fetch_PC <= fetch_target;   //the PC of the next instr!
        end
    end
    end
endmodule
