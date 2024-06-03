`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/08 12:14:51
// Design Name: 
// Module Name: Registers_tb
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


module Registers_tb(

    );
    reg Clk;
    reg [25:21] readReg1;
    reg [20:16] readReg2;
    reg [4:0] writeReg;
    reg [31:0] writeData;
    reg regWrite;
    wire [31:0] readData1;
    wire [31:0] readData2;
    
    Registers u0(
        .Clk(Clk),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .writeReg(writeReg),
        .writeData(writeData),
        .regWrite(regWrite),
        .readData1(readData1),
        .readData2(readData2)
        );
    
    parameter clk=50;
    always #(clk*2) Clk=!Clk;
    initial begin
        Clk=0;
        regWrite=0;
        readReg1=0;
        readReg2=0;
        writeReg=0;
        writeData=0;
        #100
        Clk=0;
        
        #185;
        regWrite=1'b1;
        writeReg=5'b10101;
        writeData=32'b11111111111111110000000000000000;
        
        #200;
        writeReg=5'b01010;
        writeData=32'b00000000000000001111111111111111;
        
        #200;
        regWrite=1'b0;
        writeReg=5'b00000;
        writeData=32'b00000000000000000000000000000000;
        
        #50;
        readReg1=5'b10101;
        readReg2=5'b01010;
    end
    
endmodule
