`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 11:00:04
// Design Name: 
// Module Name: Alu
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


module Alu(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] aluCtr,
    output zero,
    output [31:0] aluRes
    );
    
    reg zero;
    reg [31:0] aluRes;
   always @(input1 or input2 or aluCtr)
   begin
     if (aluCtr==4'b0010) aluRes=input1+input2;
     else if (aluCtr==4'b0110) 
     begin 
        aluRes=input1-input2;
        if (aluRes==0) zero=1; else zero=0;
     end
     else if (aluCtr==4'b0000) aluRes=input1 & input2;
     else if (aluCtr==4'b0001) aluRes=input1 | input2;
     else if (aluCtr==4'b0111)
     begin
        aluRes=(input1<input2)?1:0;
        if (aluRes==0) zero=1; else zero=0;
     end
     else if (aluCtr==4'b1100) aluRes=~(input1 | input2);
     if (aluRes==0) zero=1; else zero=0;
   end
endmodule
