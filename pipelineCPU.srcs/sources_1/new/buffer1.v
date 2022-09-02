`timescale 1ns / 1ps

module buffer1(                             // 译码部件
    input clk,
    input rst,
    
    input [31: 0] _inst,
//    input [31: 0] _pc_val,
    input _reg_we,                          // 上一条指令的写寄存器信号
    input [31: 0] _reg_wd,
    input [4: 0] _reg_wa,                   // 上一条指令的写寄存器地址
    input _pause, // 暂停信号
    input _drop, // 丢弃已经被读取的指令
    
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
    output [25: 0] inst_addr, //分支地址
    output pause,
    output drop,
    output [31: 0] output_data
    
//    output [31: 0] sel_4_0,
//    output [3: 0] pc4
    
    );
    
    reg [31: 0] inst, reg_wd;
    reg reg_we;
    reg [4: 0] reg_wa;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inst <= 32'b0;
//            inst_last <= 5'b0;
            reg_wd <= 32'b0;
            reg_we <= 1'b0;
            reg_wa <= 5'b0;
        end
        else begin
            if (_drop == 1) inst <= 32'h0; //冲刷流水线
            else if (_pause == 1) inst <= inst; // 暂停流水线，仍然译码上一个周期的指令
            else inst <= _inst; //流水线继续，译码下一条指令
            reg_wd <= _reg_wd;
            reg_we <= _reg_we;
            reg_wa <= _reg_wa;
        end
    end
    
    wire [5:0] opcode = inst[31:26];
    wire [4:0] wb_addr;
    assign wb_addr = (pause == 1) ? 5'h0 : //pause时当前指令不写入
                     (opcode == 6'b001000 || opcode == 6'b001100 || opcode == 6'b001101 || 
                     opcode == 6'b001110 ||opcode == 6'b001111 || opcode == 6'b100011) ? inst[20:16] ://写入rt
                (opcode == 6'b000000) ? inst[15:11] //写入rd
                :5'h0; //无需写入
    
    // correlation test
//    wire [31: 0] pc_val_nxt;
    corTest corTest(
        .clk(clk),
        .rst(rst),
        
        .inst(inst),
//        .inst_last(inst_last),
        .wb_addr(wb_addr), // 当前指令的写回地址
        .rs_data(rs_data),
        .rt_data(rt_data),
//        .rs_addr(), // rs寄存器地址
//        .rt_addr(),
//        .pc(pc_val),
        
        .pause(pause),
        .drop(drop)
//        .inst_nxt(inst_nxt),
//        .sel_4_0(sel_4_0),
//        .pc4(pc4)
    );
    
    // ctrl
    wire sel_rt_rd;
    ctrl ctrl(
        .opcode(inst[31: 26]),
        .func(inst[5: 0]),
        
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
        .imm(inst[15: 0]),
        
        .imm_ext(imm_ext)
    );
    
    // regFile
    regFile regFile(
        .clk(clk),
        .rst(rst),
        
        .reg_we(reg_we),
        .rs_addr(inst[25: 21]),
        .rt_addr(inst[20: 16]),
        .wb_addr(reg_wa),
        .wb_data(reg_wd),
        
        .rs_data(rs_data),
        .rt_data(rt_data),
        .output_data(output_data)
    );
    
    // mux_rt_rd
    mux5 mux_rt_rd(
        .in1(inst[20: 16]),
        .in2(inst[15: 11]),
        .sel(sel_rt_rd),
        
        .out(reg_wa_nxt)
    );
    
    assign inst_addr = inst[25: 0];
    
endmodule
