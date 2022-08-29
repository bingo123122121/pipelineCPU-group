`timescale 1ns / 1ps

module buffer1(                             // 译码部件
    input clk,
    input rst,
    
    input [31: 0] _inst,
    input [31: 0] _pc_val,
    input _reg_we,                          // 上一条指令的写寄存器信号
    input [31: 0] _reg_wd,
    input [4: 0] _reg_wa,                   // 上一条指令的写寄存器地址
    
    output reg_we_nxt,                      // 下一条指令的写寄存器信号
    output dm_we,
    output [1: 0] br_we,
    output sel_rs_sa,
    output sel_imm_rt,
    output sel_alu_dm,
    output [3: 0] alu_ctrl,
    output [31: 0] imm_ext,
    output [31: 0] rs_data,
    output [31: 0] rt_data,
    output [4: 0] reg_wa_nxt,               // 下一条指令的写寄存器地址
    output [31: 0] inst_nxt,
    output [31: 0] sel_4_0,
    output [3: 0] pc4
    
    );
    
    reg [31: 0] inst, pc_val, reg_wd;
    reg reg_we;
    reg [4: 0] reg_wa;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inst <= 32'b0;
            pc_val <= 32'b0;
            reg_wd <= 32'b0;
            reg_we <= 1'b0;
            reg_wa <= 5'b0;
        end
        else begin
            inst <= _inst;
            pc_val <= _pc_val;
            reg_wd <= _reg_wd;
            reg_we <= _reg_we;
            reg_wa <= _reg_wa;
        end
    end
    
    // correlation test
    wire [31: 0] pc_val_nxt;
    corTest corTest(
        .inst(inst),
        .pc(pc_val),
        
        .inst_nxt(inst_nxt),
        .sel_4_0(sel_4_0),
        .pc4(pc4)
    );
    
    // ctrl
    wire sel_rt_rd;
    ctrl ctrl(
        .opcode(inst_nxt[31: 26]),
        .func(inst_nxt[5: 0]),
        
        .sel_rt_rd(sel_rt_rd),
        .sel_rs_sa(sel_rs_sa),
        .sel_imm_rt(sel_imm_rt), 
        .sel_alu_dm(sel_alu_dm), 
        .alu_ctrl(alu_ctrl),
        
        .reg_we(reg_we_nxt),
        .dm_we(dm_we),
        .br_we(br_we)
    );
    
    // signExt
    signExt signExt(
        .imm(inst_nxt[15: 0]),
        
        .imm_ext(imm_ext)
    );
    
    // regFile
    regFile regFile(
        .clk(clk),
        .rst(rst),
        
        .reg_we(reg_we),
        .rs_addr(inst_nxt[25: 21]),
        .rt_addr(inst_nxt[20: 16]),
        .wb_addr(reg_wa),
        .wb_data(reg_wd),
        
        .rs_data(rs_data),
        .rt_data(rt_data)
    );
    
    // mux_rt_rd
    mux5 mux_rt_rd(
        .in1(inst_nxt[20: 16]),
        .in2(inst_nxt[15: 11]),
        .sel(sel_rt_rd),
        
        .out(reg_wa_nxt)
    );
    
endmodule
