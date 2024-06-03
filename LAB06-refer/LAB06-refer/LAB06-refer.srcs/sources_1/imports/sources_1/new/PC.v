`timescale 1ns / 1ps


module PC(
    input [31:0] PC,
    input reset,
    input clk,
    output  reg [31:0] newPC
    );
    always @ (posedge clk)
    begin
        if(reset)
            newPC <= 4;
        else
            newPC <= PC + 4;
    end
endmodule
