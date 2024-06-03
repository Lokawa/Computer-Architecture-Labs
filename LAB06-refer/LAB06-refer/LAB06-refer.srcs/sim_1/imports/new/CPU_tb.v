`timescale 1ns / 1ps


module CPU_tb(

    );
    reg clk;
    reg reset;
    TOP CPU(
        .clk(clk),
        .reset(reset)
    );
    always #8 clk = !clk;
    
    initial begin
        clk = 0;
        reset = 0;
        
        #20;
        reset =1;
        #40;
        reset = 0;
    end
endmodule
