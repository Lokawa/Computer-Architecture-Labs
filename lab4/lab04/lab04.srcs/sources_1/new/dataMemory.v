`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 12:34:59
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input Clk,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output [31:0] readData
    );
    reg [31:0] readData;
    reg [31:0] memFile[0:63];
    integer i;
    initial 
    begin
        for (i=0;i<64;i=i+1) memFile[i]=0;
    end;
    always @(address or memRead or memWrite)
    begin
        readData=(memRead==32'd0)?32'd0:memFile[address];
    end
    
    always @(negedge Clk)
    begin
       if (memWrite) memFile[address]<=writeData;
    end
endmodule
