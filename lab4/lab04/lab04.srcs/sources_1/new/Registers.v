`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 11:56:20
// Design Name: 
// Module Name: Registers
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


module Registers(
    input Clk,
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
    output [31:0] readData1,
    output [31:0] readData2
    );
    reg [31:0] readData1;
    reg [31:0] readData2;
    reg [31:0] regFile[31:0];
    always @(readReg1 or readReg2 or writeReg)
    begin
        readData1=(readReg1==5'd0)?32'd0:(regFile[readReg1]);
        readData2=(readReg2==5'd0)?32'd0:(regFile[readReg2]);
    end
    
    always @(negedge Clk)
    begin
        if (regWrite & writeReg!=5'd0) regFile[writeReg]<=writeData;
    end
endmodule
