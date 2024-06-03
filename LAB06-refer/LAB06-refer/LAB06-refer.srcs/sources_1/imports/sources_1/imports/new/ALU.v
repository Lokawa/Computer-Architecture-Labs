`timescale 1ns / 1ps


module ALU(
    input clk,
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] ALUctrOut,
    input [4:0] shift,
    output reg [31:0] ALUres,
    output reg zero,    //zero = 1, if ALUres == 0.
    output reg ret      //ret = 1, if jr.
    );
    always @ (posedge clk)
    begin
        if(ALUctrOut == 4'b0010)    //add
            ALUres = input1 + input2;
        else if(ALUctrOut == 4'b0110)  //sub
        begin
            ALUres = input1 - input2;
        end
        else if (ALUctrOut == 4'b0000)    //AND   
        begin
            ALUres = input1 & input2;
        end
        else if (ALUctrOut == 4'b0001)    //OR
        begin
            ALUres = input1 | input2;
        end    
        else if (ALUctrOut == 4'b1100)    //NOR
        begin
            ALUres = ~(input1 | input2); 
        end
        else if (ALUctrOut == 4'b0111)    //slt
        begin
            ALUres = input1 < input2; 
        end
        else if (ALUctrOut == 4'b1000)    //sll
        begin
            ALUres = input2 << shift;
        end
        else if (ALUctrOut == 4'b1001)    //srl
        begin
            ALUres = input2 >> shift;
        end
        else if (ALUctrOut == 4'b1111)    //jr
        begin
            ALUres = input1;
        end
        
        if (ALUctrOut == 4'b1111)    //jr
            ret = 1;
        else 
            ret = 0;
        
        if (ALUres == 0)
                zero = 1;
            else
                zero = 0;
    end
endmodule
