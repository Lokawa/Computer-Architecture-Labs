`timescale 1ns / 1ps


module SignExt(
    input [15:0] inst,
    output wire [31:0] data
    );
    
    assign data = {{16{inst[15]}},inst[15:0]};
    
endmodule
