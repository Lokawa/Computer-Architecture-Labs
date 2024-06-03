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
            newPC=4; //在 reset 时为避免 Race and Hazard，直接将 newPC 置为 4，避免读取上一个被清零的 PC
        else
            newPC=PC+4;// 请给出由PC到newPC指令更新计数的逻辑
    end
endmodule
