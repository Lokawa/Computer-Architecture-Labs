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

     //��� beq��j��jr ����PCupdateģ�飬���Կ��ǲ������涨��õı�������Ҳ�����Լ����壬����ͳһ��
endmodule   
