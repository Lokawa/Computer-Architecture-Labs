`timescale 1ns / 1ps


module Ext(
    input Extop,
    input [15:0] inst,
    output wire [31:0] data
    );
    
    wire [31:0] data0;
    wire [31:0] data1;
    
    ZeroExt Z1(
        .inst(inst),
        .data(data0)
    );
    
    SignExt S1(
        .inst(inst),
        .data(data1)
    );
    
    assign data = (Extop) ? (data1) : (data0);
    
endmodule
