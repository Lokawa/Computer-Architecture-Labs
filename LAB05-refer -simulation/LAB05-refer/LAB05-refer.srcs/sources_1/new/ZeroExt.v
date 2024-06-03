`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SJTU
// Engineer: Zhengxiang Huang
// 
// Create Date: 2022/05/01 22:37:39
// Design Name: ZeroExt
// Module Name: ZeroExt
// Project Name: lab05
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


module ZeroExt(
    input [15:0] inst,
    output wire [31:0] data
    );
    assign data = {{16{1'b0}},inst};
    
endmodule
