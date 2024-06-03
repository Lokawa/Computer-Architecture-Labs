`timescale 1ns / 1ps

module PCupdate(
    input [31:0] newPC,
    input PCsrc,
    input [31:0] offset,
    input [25:0] target,
    input Jump,
    input ret,
    input [31:0] retAddr,
    output wire [31:0] nextPC
    );

    assign nextPC=(PCsrc)? newPC+offset:((Jump)? ((ret)?retAddr:{newPC[31:28],target<<2}):newPC);

     //针对 beq，j，jr 更新PCupdate模块，可以考虑采用上面定义好的变量名，也可以自己定义，保持统一。
endmodule   
