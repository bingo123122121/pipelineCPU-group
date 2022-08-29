`timescale 1ns / 1ps

module alu(
    input clk,
    input rst,
    
    input [3: 0] alu_ctrl,              // 0-9对应10种运算
    
    input [31: 0] num1,                 // 输入数据1
    input [31: 0] num2,                 // 输入数据2
    
    output [31: 0] ans                  // 运算结果
    );
    
    assign ans = (alu_ctrl == 0) ? num1 + num2 :
                 (alu_ctrl == 1) ? num1 - num2 :
                 (alu_ctrl == 2) ? num1 & num2 :
                 (alu_ctrl == 3) ? num1 | num2 :
                 (alu_ctrl == 4) ? num1 ^ num2 :
                 (alu_ctrl == 5) ? {num2[15: 0], 16'b0} :
                 (alu_ctrl == 6) ? !(num1 | num2) :
                 (alu_ctrl == 7) ? ((num1 < num2) ? 32'b1 : 32'b0) : 
                 (alu_ctrl == 8) ? (num2 << num1) :
                 (alu_ctrl == 9) ? !(num2 >> num1) :
                 32'b0;
                 
endmodule
