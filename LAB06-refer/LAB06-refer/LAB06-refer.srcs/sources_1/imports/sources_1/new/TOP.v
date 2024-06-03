`timescale 1ns / 1ps


module TOP(
    input reset,
    input clk
    );
    //IF
    wire wrongPrediction;
    wire [31:0] wrongPC;
    wire [31:0] buf1_PC;
    wire [31:0] buf1_IR;
    wire [31:0] nextPC;
    wire setPC;
    wire stall;
    wire [31:0] fetch_PC;
    instrFetch IF(
        .clk(clk),
        .reset(reset),
        .nextPC(nextPC),  //jump, beq destination
        .setPC(setPC),    //signal: there is a jump/beq!
        .stall(stall),
        .buf1_PC(buf1_PC),
        .buf1_IR(buf1_IR),
        .wrongPrediction(wrongPrediction),
        .wrongPC(wrongPC),
        .fetch_PC(fetch_PC)
    );
    
    //ID
    reg possibleForward2;         //forwarding
    wire [4:0] forwardAddr2;      //forwarding
    wire [31:0] forwardData2;     //forwarding
    wire possibleStall;
    wire [4:0] stallAddr;
    wire possibleForward1;
    wire [4:0] forwardAddr1;
    wire [31:0] forwardData1;
    //
    reg [4:0] buf4_writeAddr;  //WB
    reg buf4_regWrite;         //WB
    wire [31:0] writeBackData; //WB
    //
    wire buf2_ALUsrc;
    wire buf2_MemToReg;
    wire buf2_regWrite;
    wire buf2_memRead;
    wire buf2_memWrite;
    wire buf2_Extop;
    wire [2:0] buf2_ALUop;
    wire [4:0] buf2_writeAddr;
    wire [31:0] buf2_A;
    wire [31:0] buf2_B;
    wire [31:0] buf2_IR;
    instrDecode ID(
        .clk(clk),
        .reset(reset),
        .buf1_PC(buf1_PC),
        .buf1_IR(buf1_IR),
        .possibleStall(possibleStall),
        .stallAddr(stallAddr),
        .possibleForward1(possibleForward1),
        .forwardAddr1(forwardAddr1),
        .forwardData1(forwardData1),
        .possibleForward2(possibleForward2),
        .forwardAddr2(forwardAddr2),
        .forwardData2(forwardData2),
        .L_writeReg(buf4_writeAddr),   /////write back!
        .L_writeData(writeBackData),   //////
        .L_regWrite(buf4_regWrite),   /////
        .buf2_ALUsrc(buf2_ALUsrc),
        .buf2_MemToReg(buf2_MemToReg),
        .buf2_regWrite(buf2_regWrite),
        .buf2_memRead(buf2_memRead),
        .buf2_memWrite(buf2_memWrite),
        .buf2_Extop(buf2_Extop),
        .buf2_ALUop(buf2_ALUop),
        .buf2_A(buf2_A),
        .buf2_B(buf2_B),
        .buf2_IR(buf2_IR),
        .buf2_writeAddr(buf2_writeAddr),
        .wrongPrediction(wrongPrediction),
        .wrongPC(wrongPC),
        .nextPC(nextPC),
        .setPC(setPC),
        .stall(stall),
        .fetch_PC(fetch_PC)
    );
    
    //EX
    wire buf3_MemToReg;
    wire buf3_regWrite;
    wire [4:0] buf3_writeAddr;
    wire [31:0] buf3_ALUres;
    wire [31:0] buf3_writeData;
    wire buf3_memRead;
    wire buf3_memWrite;
    execution EX(
        .clk(clk),
        .reset(reset),
        .buf2_Extop(buf2_Extop),
        .buf2_IR(buf2_IR),
        .buf2_ALUop(buf2_ALUop),
        .buf2_ALUsrc(buf2_ALUsrc),
        .buf2_A(buf2_A),
        .buf2_B(buf2_B),
        .buf2_MemToReg(buf2_MemToReg),
        .buf2_regWrite(buf2_regWrite),
        .buf2_memRead(buf2_memRead),
        .buf2_memWrite(buf2_memWrite),
        .buf2_writeAddr(buf2_writeAddr),
        .buf3_MemToReg(buf3_MemToReg),
        .buf3_regWrite(buf3_regWrite),
        .buf3_writeAddr(buf3_writeAddr),
        .buf3_ALUres(buf3_ALUres),
        .buf3_writeData(buf3_writeData),
        .buf3_memRead(buf3_memRead),
        .buf3_memWrite(buf3_memWrite),
        .possibleStall(possibleStall),
        .stallAddr(stallAddr),
        .possibleForward1(possibleForward1),
        .forwardAddr1(forwardAddr1),
        .forwardData1(forwardData1)
    );

    //MEM
    wire [31:0] memOut;
    // memory operation for sw and lw.
    DataMemory DMEM(
        .clk(clk),
        .reset(reset),
        .addr(buf3_ALUres),
        .writeData(buf3_writeData),
        .memWrite(buf3_memWrite),
        .memRead(buf3_memRead),
        .readData(memOut)
    );
    reg M_MemToReg;
    reg M_regWrite;
    reg [4:0] M_writeAddr;
    reg [31:0] M_ALUres;
    always @ (posedge clk)
    begin
        if(reset)
        begin
            M_MemToReg<=0;
            M_regWrite<=0;
            M_writeAddr<=0;
            M_ALUres<=0;
            possibleForward2<=0;
        end
        else
        begin
            M_MemToReg<=buf3_MemToReg;
            M_regWrite<=buf3_regWrite;
            M_writeAddr<=buf3_writeAddr;
            M_ALUres<=buf3_ALUres;
            possibleForward2<=buf3_MemToReg;
        end
    end
    assign forwardAddr2 = M_writeAddr;
    assign forwardData2 = (M_MemToReg) ? (memOut) : (M_ALUres);
    reg [31:0] buf4_memOut;
    reg [31:0] buf4_ALUres;
    reg buf4_MemToReg;    
    always @ (negedge clk)
    begin
        buf4_MemToReg<=M_MemToReg;
        buf4_regWrite<=M_regWrite;
        buf4_writeAddr<=M_writeAddr;        
        buf4_ALUres<=M_ALUres;
        buf4_memOut<=memOut;
    end
    
    //WB
    
    assign writeBackData = (buf4_MemToReg) ? (buf4_memOut) : (buf4_ALUres);
endmodule