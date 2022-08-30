`timescale 1ns / 1ps

module ctrl(
    input [5: 0] opcode,
    input [5: 0] func,
    
    output sel_rt_rd,           // 目的寄存器, 0-rt, 1-rd
    output sel_rs_sa,           // 操作数1, 0-rs, 1-sa
    output sel_imm_rt,          // 操作数2, 0-imm, 1-rt 
    output sel_alu_dm,          // 输出数据, 0-alu, 1-dm
    output [3: 0] alu_ctrl,     // 运算类型，共10种
    
    output reg_we,              // 写寄存器堆使能
    output dm_we,               // 写数据存储器使能
    output [1: 0] br_we         // 写分支跳转使能
    );
    
    wire [4: 0] ins_type;
    
    assign ins_type = (opcode == 6'b001000) ? 0 :               // addi
                      (opcode == 6'b001100) ? 1 :               // andi
                      (opcode == 6'b001101) ? 2 :               // ori
                      (opcode == 6'b001110) ? 3 :               // xori
                      (opcode == 6'b001111) ? 4 :               // lui
                      (opcode == 6'b100011) ? 5 :               // lw
                      (opcode == 6'b101011) ? 6 :               // sw
                      (opcode == 6'b000100) ? 7 :               // beq
                      (opcode == 6'b000010) ? 8 :               // j
                      (opcode == 6'b000000) ? (
                      (func == 6'b100000) ? 9 :                 // add
                      (func == 6'b100010) ? 10 :                // sub
                      (func == 6'b100100) ? 11 :                // and
                      (func == 6'b100101) ? 12 :                // or
                      (func == 6'b100110) ? 13 :                // xor
                      (func == 6'b100111) ? 14 :                // nor
                      (func == 6'b101010) ? 15 :                // slt
                      (func == 6'b000000) ? 16 :                // sll
                      (func == 6'b000010) ? 17 :                // srl
                      18) : 18;                                 // 未定义指令
    
    // 选择信号0选前者，1选后者
    assign sel_rt_rd = (ins_type >= 9 && ins_type <= 17) ? 1 : 0;
    assign sel_rs_sa = (ins_type == 16 || ins_type == 17) ? 1 : 0;
    assign sel_imm_rt = (ins_type >= 9 && ins_type <= 17) ? 1 : 0;
    assign sel_alu_dm = (ins_type == 5) ? 1 : 0;
    
    // 将指令对应到需要的运算，具体对应关系看excel表
    assign alu_ctrl = (ins_type == 0 || ins_type == 5 || ins_type == 6 || ins_type == 9) ? 4'h0 :   // +
                      (ins_type == 10) ? 4'h1 :                     // -
                      (ins_type == 1 || ins_type == 11) ? 4'h2 :    // &
                      (ins_type == 2 || ins_type == 12) ? 4'h3 :    // |
                      (ins_type == 3 || ins_type == 13) ? 4'h4 :    // ^
                      (ins_type == 4) ? 4'h5 :                      // lui
                      (ins_type == 14) ? 4'h6 :                     // nor
                      (ins_type == 15) ? 4'h7 :                     // slt
                      (ins_type == 16) ? 4'h8 :                     // sll
                      (ins_type == 17) ? 4'h9 :                     // srl
                      4'ha;
    assign reg_we = (ins_type <= 5 || ins_type >= 9) ? 1 : 0;
    assign dm_we = (ins_type == 6) ? 1 : 0;
    assign br_we = (ins_type == 7) ? 2'b01 :
                   (ins_type == 8) ? 2'b10 : 0;
    
    
endmodule
