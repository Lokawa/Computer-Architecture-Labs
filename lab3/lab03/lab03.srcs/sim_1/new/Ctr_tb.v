`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 09:09:52
// Design Name: 
// Module Name: Ctr_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Ctr_tb(
    );
    
    reg [5:0] OpCode;
    wire RegDst;
    wire AluSrc;
    wire MemToReg;
    wire RegWrite;
    wire MemRead;
    wire MemWrite;
    wire Branch;
    wire [1:0] AluOp;
    wire Jump;
    
    
     
     initial begin
        OpCode= 0;
        #100;
        
        #100 OpCode=6'b000000;//R
        #100 OpCode=6'b100011;//lw
        #100 OpCode=6'b101011;//sw
        #100 OpCode=6'b000100;//beq
        #100 OpCode=6'b000010;//j
     end   
     Ctr u0(
        .OpCode(OpCode),
        .RegDst(RegDst),
        .AluSrc(AluSrc),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .AluOp(AluOp),
        .Jump(Jump)
        );
endmodule
