`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 15:17:13
// Design Name: 
// Module Name: signext_tb
// Project Name: 
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


module signext_tb(

    );
    wire [31:0] data;
    reg [15:0] inst;
    
    signext u0(
        .data(data),
        .inst(inst)
        );
    initial begin
        inst=0;
        
        #100;
        inst=16'b1011000111010011;
        
        #400;
        inst=16'b0111011101101101;
     end;
endmodule
