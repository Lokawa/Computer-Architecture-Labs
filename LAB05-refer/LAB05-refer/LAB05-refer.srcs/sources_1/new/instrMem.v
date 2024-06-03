`timescale 1ns / 1ps

module instrMem(
    input [31:0] readAddr,
    input clk,
    input reset,
    output reg [31:0] instr
    );
    reg [31:0] instrMEM[64:0];
    initial begin
        $readmemb("Instruction.txt",instrMEM);
    end
    always @ (posedge clk)
    // 上升沿触发
    begin
        if(reset)
            instr <= instrMEM[0];
        else
            instr<=instrMEM[readAddr>>2];//请给出读取命令的逻辑。（可以借助移位操作来索引，需要注意内存是word aligned，而寄存器是byte-addressed）
    end
endmodule
