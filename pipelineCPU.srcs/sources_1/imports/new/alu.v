`timescale 1ns / 1ps

module alu(
    input clk,
    input rst,
    
    input [3: 0] alu_ctrl,          // 0-add/addiu£¬1-xor£¬2-lui
    
    input [31: 0] num1,
    input [31: 0] num2,
    
    output [31: 0] ans
    );
    
    wire [31: 0] add_ans = num1 + num2;
    wire [31: 0] xor_ans = num1 ^ num2;
    wire [31: 0] lui_ans = {num2[15: 0], 16'b0};
    
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
