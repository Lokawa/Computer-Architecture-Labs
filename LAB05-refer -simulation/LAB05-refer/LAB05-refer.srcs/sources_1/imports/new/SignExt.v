`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SJTU
// Engineer: Zhengxiang Huang
// 
// Create Date: 2022/04/27 15:25:45
// Design Name: SignExt
// Module Name: SignExt
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


module SignExt(
    input [15:0] inst,
    output wire [31:0] data
    );
    
    assign data = {{16{inst[15]}},inst[15:0]};
    
endmodule
