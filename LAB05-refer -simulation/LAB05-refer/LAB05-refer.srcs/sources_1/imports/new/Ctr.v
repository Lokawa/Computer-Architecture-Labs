`timescale 1ns / 1ps

module Ctr(
//为了实现 16 条指令的功能，必须增加 2 个控制信号，分别是：Extop 控制 I-type 的extension 操作；和 call 控制 jal 将 PC+4 写回 31 号寄存器。
    input [5:0] opCode,
    output reg call, 
    output reg regDst,
    output reg ALUsrc,
    output reg MemToReg,
    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg Extop,
    output reg Branch,
    output reg [2:0] ALUop,
    output reg Jump
    );
    always @(opCode)
    begin
        case(opCode)
        6'b000000:    // R-type
        begin
            regDst = 1;
            ALUsrc = 0;
            MemToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 0;
            ALUop=3'b010;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        6'b100011:    // lw
        begin
            regDst = 0;
            ALUsrc = 1;
            MemToReg = 1;
            regWrite = 1;
            memRead = 1;
            memWrite = 0;
            Extop = 1;
            Branch = 0;
            ALUop=3'b000;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        6'b101011:    //sw
        begin
            regDst = 0;
            ALUsrc = 1;
            MemToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 1;
            Extop = 1;
            Branch = 0;
            ALUop=3'b000;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        6'b000100:    //beq
        begin
            regDst = 0;
            ALUsrc = 0;
            MemToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 1;
            ALUop=3'b001;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        6'b000010:    //j
        begin
            regDst = 0;
            ALUsrc = 0;
            MemToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 0;
            ALUop=3'b100;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 1;
            call = 0;
        end
        6'b001000:    //addi
        begin
            regDst = 0;
            ALUsrc = 1;
            MemToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            Extop = 1;
            Branch = 0;
            ALUop=3'b110;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        6'b001100:    //andi
        begin
            regDst = 0;
            ALUsrc = 1;
            MemToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 0;
            ALUop=3'b111;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        6'b001101:    //ori
        begin
            regDst = 0;
            ALUsrc = 1;
            MemToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 0;
            ALUop=3'b011;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        6'b000011:    //jal
        begin
            regDst = 0;
            ALUsrc = 0;
            MemToReg = 0;
            regWrite = 1;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 0;
            ALUop=3'b100;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 1;
            call = 1;
        end
        default:
        begin
            regDst = 0;
            ALUsrc = 0;
            MemToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 0;
            ALUop=3'b000;// 请根据16条指令重新编写ALUop的索引规则，并更新这里ALUop的赋值
            Jump = 0;
            call = 0;
        end
        endcase
    end
endmodule
