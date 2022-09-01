`timescale 1ns / 1ps

// cpu就是按照电路图连线，组合各个组件的过程
module cpu(
    input clk,
    input rst
    );
    
    // 取指部件
    wire [1: 0] br_we;
    wire [31: 0] rs_data;
    wire [31: 0] rt_data;
//    wire [3: 0] pc4;
    wire [25: 0] inst_addr;
//    wire [31: 0] sel_4_0;
    wire pause;
    wire drop;
    
    wire [31: 0] inst_val;
//    wire [31: 0] pc_val;
    
    buffer0 buffer0(
        .clk(clk),
        .rst(rst),
        
        ._br_we(br_we),
        ._rs_data(rs_data),
        ._rt_data(rt_data),
//        ._pc4(pc4),
        ._inst_addr(inst_addr),
//        ._sel_4_0(sel_4_0),
        .pause(pause),
    
        .inst_val(inst_val)
//        .pc_val(pc_val)
    );
    
    // 译码部件
    wire reg_we4;                        // 上一条指令的写寄存器信号
    wire [31: 0] reg_wd;                 // 上一条指令要写的数据
    wire [4: 0] reg_wa4;                 // 上一条指令的写寄存器地址
    
    wire reg_we1;                        // 下一条指令的写寄存器信号
    wire dm_we1;
    wire sel_rs_sa;
    wire sel_imm_rt;
    wire sel_alu_dm;
    wire [3: 0] alu_ctrl;
    wire [31: 0] imm_ext;
    wire [4: 0] reg_wa1;               // 下一条指令的写寄存器地址
    
    buffer1 buffer1(
        .clk(clk),
        .rst(rst),
        
        ._inst(inst_val),
//        ._pc_val(pc_val),
        ._reg_we(reg_we4),
        ._reg_wd(reg_wd),
        ._reg_wa(reg_wa4),
        ._pause(pause),
        ._drop(drop),
        
        .reg_we_nxt(reg_we1),
        .dm_we(dm_we1),
        .br_we(br_we),
        .sel_rs_sa(sel_rs_sa),
        .sel_imm_rt(sel_imm_rt),
        .sel_alu_dm(sel_alu_dm),
        .alu_ctrl(alu_ctrl),
        .imm_ext(imm_ext),
        .rs_data(rs_data),
        .rt_data(rt_data),
        .reg_wa_nxt(reg_wa1),
        .inst_addr(inst_addr),
        .pause(pause),
        .drop(drop)
//        .sel_4_0(sel_4_0),
//        .pc4(pc4)
    );
    
    // 运算部件
    wire reg_we2;
    wire dm_we2;
    wire sel_alu_dm2;
    wire [31: 0] alu_ans2;
    wire [31: 0] rt_data2;
    wire [4: 0] reg_wa2;
    
    buffer2 buffer2(
        .clk(clk),
        .rst(rst),
        
        ._reg_we(reg_we1),
        ._dm_we(dm_we1),
        ._sel_rs_sa(sel_rs_sa),
        ._sel_imm_rt(sel_imm_rt),
        ._sel_alu_dm(sel_alu_dm),
        ._alu_ctrl(alu_ctrl),
        ._imm_ext(imm_ext),
        ._rs_data(rs_data),
        ._rt_data(rt_data),
        ._reg_wa(reg_wa1),
        .pause(pause),
        
        .reg_we_(reg_we2),
        .dm_we_(dm_we2),
        .sel_alu_dm_(sel_alu_dm2),
        .alu_ans(alu_ans2),
        .rt_data_(rt_data2),
        .reg_wa_(reg_wa2)
    );
    
    // 取数部件
    wire reg_we3;
    wire sel_alu_dm3;
    wire [31: 0] dm_data;
    wire [31: 0] alu_ans3;
    wire [4: 0] reg_wa3;
    
    buffer3 buffer3(
        .clk(clk),
        .rst(rst),
        
        ._reg_we(reg_we2),
        ._dm_we(dm_we2),
        ._sel_alu_dm(sel_alu_dm2),
        ._alu_ans(alu_ans2),
        ._rt_data(rt_data2),
        ._reg_wa(reg_wa2),
        
        .reg_we_(reg_we3),
        .sel_alu_dm_(sel_alu_dm3),
        .dm_data(dm_data),
        .alu_ans_(alu_ans3),
        .reg_wa_(reg_wa3)
    );
    
    // 写回部件
    buffer4 buffer4(
        .clk(clk),
        .rst(rst),
        
        ._reg_we(reg_we3),
        ._sel_alu_dm(sel_alu_dm3),
        ._dm_data(dm_data),
        ._alu_ans(alu_ans3),
        ._reg_wa(reg_wa3),
        
        .reg_we_(reg_we4),
        .reg_wd(reg_wd),
        .reg_wa_(reg_wa4)
    );
    
endmodule
