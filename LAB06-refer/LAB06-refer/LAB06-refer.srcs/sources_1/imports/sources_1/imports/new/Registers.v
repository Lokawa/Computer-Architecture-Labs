`timescale 1ns / 1ps


module Registers(
    input clk,
    input reset, //reset
    input [25:21] readReg1,
    input [20:16] readReg2,
    input [15:11] writeReg,
    input [31:0] writeData,
    input regWrite,
    input call,
    input [31:0] curPC,
    output reg [31:0] readData1,
    output reg [31:0] readData2
    );
    reg [31:0] regFile[31:0];
    initial begin
        $readmemh("Register.txt",regFile);
    end
    always @(posedge clk)
    begin
        if(reset)
            begin
                regFile[0]=0;
                regFile[1]=0;
                regFile[2]=0;
                regFile[3]=0;
                regFile[4]=0;
                regFile[5]=0;
                regFile[6]=0;
                regFile[7]=0;
                regFile[8]=0;
                regFile[9]=0;
                regFile[10]=0;
                regFile[11]=0;
                regFile[12]=0;
                regFile[13]=0;
                regFile[14]=0;
                regFile[15]=0;
                regFile[16]=0;
                regFile[17]=0;
                regFile[18]=0;
                regFile[19]=0;
                regFile[20]=0;
                regFile[21]=0;
                regFile[22]=0;
                regFile[23]=0;
                regFile[24]=0;
                regFile[25]=0;
                regFile[26]=0;
                regFile[27]=0; 
                regFile[28]=0;
                regFile[29]=0;
                regFile[30]=0;
                regFile[31]=0;               
            end
        else
        begin
            if(regWrite)
            begin
                regFile[writeReg] = writeData;
            end
        end
    end
    
    always @(readReg1 or readReg2 or regWrite or reset or writeData or regFile[readReg1] or regFile[readReg2])
        begin
            readData1 = regFile[readReg1];
            readData2 = regFile[readReg2];
        end
    always @(negedge clk)
        begin
        if(call)
            regFile[31] <= curPC;
        end
endmodule
