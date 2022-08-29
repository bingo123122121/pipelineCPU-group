`timescale 1ns / 1ps

module brUnit(
    input clk,
    input rst,

    input [31: 0] rs_data,          // rs寄存器值
    input [31: 0] rt_data,          // rt寄存器值
    input [31: 0] inst,             // 当前指令
    input [3: 0] pc4,               // pc高4位
    input [1: 0] br_we,             // 01-beq, 10-j
    
    output pc_jmp,
    output pc_br,
    output [25: 0] pc_tgt,
    output [15: 0] pc_off
    
    );

    assign pc_br = (rs_data == rt_data && br_we == 2'b01) ? 1 : 0;
    assign pc_jmp = (rs_data == rt_data && br_we == 2'b10) ? 1 : 0;
    assign pc_off = inst[15: 0];
    assign pc_tgt = inst[25: 0];
    
    
    
endmodule
