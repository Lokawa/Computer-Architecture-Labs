`timescale 1ns / 1ps

module ZeroExt(
    input [15:0] inst,
    output wire [31:0] data
    );
    assign data = {{16{1'b0}},inst};
    
endmodule
