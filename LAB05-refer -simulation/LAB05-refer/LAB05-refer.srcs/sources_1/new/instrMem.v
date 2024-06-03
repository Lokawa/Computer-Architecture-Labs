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
    // �����ش���
    begin
        if(reset)
            instr <= instrMEM[0];
        else
            instr<=instrMEM[readAddr>>2];//�������ȡ������߼��������Խ�����λ��������������Ҫע���ڴ���word aligned�����Ĵ�����byte-addressed��
    end
endmodule
