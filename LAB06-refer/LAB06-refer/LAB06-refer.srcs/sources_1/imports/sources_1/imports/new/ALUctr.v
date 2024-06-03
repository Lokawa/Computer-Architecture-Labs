`timescale 1ns / 1ps

module ALUctr(
    input [2:0] ALUop,
    input [5:0] Funct,
    output reg [3:0] ALUctrOut
    );
    always @(ALUop or Funct)
    begin
        casex({ALUop,Funct})
            9'b000xxxxxx: ALUctrOut[3:0] = 4'b0010;    //lw,sw,addi
            9'b001xxxxxx: ALUctrOut[3:0] = 4'b0110;    //beq
            9'b011xxxxxx: ALUctrOut[3:0] = 4'b0000;    //andi
            9'b010xxxxxx: ALUctrOut[3:0] = 4'b0001;    //ori
            9'b100100000: ALUctrOut[3:0] = 4'b0010;    //add
            9'b100100010: ALUctrOut[3:0] = 4'b0110;    //sub
            9'b100100100: ALUctrOut[3:0] = 4'b0000;    //and
            9'b100100101: ALUctrOut[3:0] = 4'b0001;    //or
            9'b100101010: ALUctrOut[3:0] = 4'b0111;    //set on less than
            9'b100000000: ALUctrOut[3:0] = 4'b1000;    //sll
            9'b100000010: ALUctrOut[3:0] = 4'b1001;    //srl
            9'b100001000: ALUctrOut[3:0] = 4'b1111;    //jr
        endcase
    end
endmodule
