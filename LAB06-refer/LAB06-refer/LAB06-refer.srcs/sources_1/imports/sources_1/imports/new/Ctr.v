`timescale 1ns / 1ps


module Ctr(
    input clk,
    input reset,
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
    always @(posedge clk)
    begin
    if(reset)
    begin
        regDst = 0;
        ALUsrc = 0;
        MemToReg = 0;
        regWrite = 0;
        memRead = 0;
        memWrite = 0;
        Extop = 0;
        Branch = 0;
        ALUop = 3'b000;
        Jump = 0;
        call = 0;
    end
    else
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
            ALUop = 3'b100;
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
            ALUop = 3'b000;
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
            ALUop = 3'b000;
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
            ALUop = 3'b001;
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
            ALUop = 3'b000;
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
            ALUop = 3'b000;
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
            ALUop = 3'b011;
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
            ALUop = 3'b010;
            Jump = 0;
            call = 0;
        end
        6'b000011:    //jal
        begin
            regDst = 0;
            ALUsrc = 0;
            MemToReg = 0;
            regWrite = 0;
            memRead = 0;
            memWrite = 0;
            Extop = 0;
            Branch = 0;
            ALUop = 3'b000;
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
            ALUop = 3'b000;
            Jump = 0;
            call = 0;
        end
        endcase
    end
    end
endmodule
