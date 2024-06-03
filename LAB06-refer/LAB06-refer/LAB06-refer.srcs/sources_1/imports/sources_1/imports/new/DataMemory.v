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
        $readmemh("Data1.txt",memFile);
    end
    // The Data Memory is byte-addressed, but access only by word-aligned way. 
    
    always@ (posedge clk)
        begin
            readData = memFile[addr >> 2];
        end
    always@ (posedge clk)
        begin
        if(reset)
        begin
            //do nothing, not allowed to write!
        end
        else if (memWrite)
        begin
            memFile[addr >> 2] = writeData;
        end
        end
endmodule
