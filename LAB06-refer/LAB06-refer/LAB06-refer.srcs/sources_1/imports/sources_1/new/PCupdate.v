`timescale 1ns / 1ps


module PCupdate(
    input [31:0] newPC,
    input PCsrc,
    input [31:0] offset,
    input ret,
    input [31:0] retAddr,
    output wire [31:0] nextPC
    );
    wire [31:0] branchtarget;
    assign branchtarget = newPC + offset;
    wire [31:0] nonretaddr;
    assign nonretaddr = (PCsrc) ? (branchtarget) : (newPC);
    assign nextPC = (ret) ? (retAddr) :(nonretaddr);
endmodule
