`timescale 1ns / 1ps


module DataMemory(
    input clk,
    input reset,
    input [31:0] addr,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output reg [31:0] readData
    );
    reg [31:0] memFile [63:0];
    initial
    begin
        $readmemh("Data.txt",memFile);
    end
    // The Data Memory is byte-addressed, but access only by word-aligned way. 
    always@ (memRead or addr)
        begin
            readData=(memRead && memWrite==0)?memFile[addr>>2]:0;//��Ӧsw��lw�����������Ķ�����
        end
    always@ (negedge clk)
        begin
        if (memWrite)
            memFile[addr>>2]<=writeData;//��Ӧsw��lw������������д����
        end
endmodule
