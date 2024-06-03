`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 10:28:46
// Design Name: 
// Module Name: ALUCtr_tb
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


module ALUCtr_tb(

    );
    reg [1:0] ALUOp;
    reg [5:0] Funct;
    wire [3:0] ALUCtrOut;
    
    
    
    initial begin
        ALUOp=0;
        Funct=0;
        #100;
        
        #100 ALUOp=2'b00;Funct=6'b000000;
        #100 ALUOp=2'b11;Funct=6'b111111;
        #100 ALUOp=2'b10;Funct=6'b110000;
        #100 ALUOp=2'b10;Funct=6'b110010;
        #100 ALUOp=2'b10;Funct=6'b110100;
        #100 ALUOp=2'b10;Funct=6'b110101;
        #100 ALUOp=2'b10;Funct=6'b111010;
     end
     ALUCtr u0(
        .ALUOp(ALUOp),
        .Funct(Funct),
        .ALUCtrOut(ALUCtrOut)
        );
endmodule
