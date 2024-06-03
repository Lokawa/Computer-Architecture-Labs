`timescale 1ns / 1ps

module instrMem(
    input [31:0] readAddr,
    input clk,
    input reset,
    output reg [31:0] instr
    );
    reg [31:0] instrMEM[64:0];
    initial begin
        $readmemb("Instruction0.txt",instrMEM);
    end
    always @ (posedge clk)
    // triggered at the positive edge of the clk
    begin
        if(reset)
            instr <= instrMEM[0];
        else
            instr <= instrMEM[readAddr >> 2];
    end
endmodule
