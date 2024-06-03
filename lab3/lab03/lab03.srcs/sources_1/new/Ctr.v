`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 23:18:45
// Design Name: 
// Module Name: Ctr
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


module Ctr(
    input [5:0] OpCode,
    output RegDst,
    output AluSrc,
    output MemToReg,
    output RegWrite,
    output MemRead,
    output MemWrite,
    output Branch,
    output [1:0] AluOp,
    output Jump
    );
    reg RegDst;
    reg AluSrc;
    reg MemToReg;
    reg RegWrite;
    reg MemRead;
    reg MemWrite;
    reg Branch;
    reg [1:0] AluOp;
    reg Jump;
    always @(OpCode)
    begin
        case(OpCode)
        6'b000000:
        begin
            RegDst=1;
            AluSrc=0;
            MemToReg=0;
            RegWrite=1;
            MemRead=0;
            MemWrite=0;
            Branch=0;
            AluOp=2'b10;
            Jump=0;
         end
         6'b100011:
         begin
            RegDst=0;
            AluSrc=1;
            MemToReg=1;
            RegWrite=1;
            MemRead=1;
            MemWrite=0;
            Branch=0;
            AluOp=2'b00;
            Jump=0;
         end
         6'b101011:
         begin
            RegDst=0;
            AluSrc=1;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=1;
            Branch=0;
            AluOp=2'b00;
            Jump=0;
         end
         6'b000100:
         begin
            RegDst=0;
            AluSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            Branch=1;
            AluOp=2'b01;
            Jump=0;
         end
         6'b000010:
         begin
            RegDst=0;
            AluSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            Branch=0;
            AluOp=2'b00;
            Jump=1;
         end
         default:
         begin
            RegDst=0;
            AluSrc=0;
            MemToReg=0;
            RegWrite=0;
            MemRead=0;
            MemWrite=0;
            Branch=0;
            AluOp=2'b00;
            Jump=0;
          end
       endcase
   end
   
endmodule
