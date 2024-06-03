`timescale 1ns / 1ps

module ALUctr(
    input [2:0] ALUop,
    input [5:0] Funct,
    output reg [3:0] ALUctrOut
    );
    always @(ALUop or Funct)
    begin
        casex({ALUop,Funct})
            9'b010100000:ALUctrOut=4'b0010;//add
            9'b010100010:ALUctrOut=4'b0110;//sub
            9'b010100100:ALUctrOut=4'b0000;//and
            9'b010100101:ALUctrOut=4'b0001;//or
            9'b010100111:ALUctrOut=4'b1100;//nor
            9'b010000000:ALUctrOut=4'b0101;//sll
            9'b010000010:ALUctrOut=4'b0111;//srl
            9'b010101010:ALUctrOut=4'b1000;//slt
            9'b010001000:ALUctrOut=4'b1111;//jr
            9'b000xxxxxx:ALUctrOut=4'b0010;//sw,lw
            9'b001xxxxxx:ALUctrOut=4'b0110;//beq
            9'b100xxxxxx:ALUctrOut=4'b1110;//j,jal
            9'b110xxxxxx:ALUctrOut=4'b0010;//addi
            9'b111xxxxxx:ALUctrOut=4'b0000;//andi
            9'b011xxxxxx:ALUctrOut=4'b0001;//ori
            //请根据更新后的ALUop更新这里的代码
        endcase
    end
endmodule
