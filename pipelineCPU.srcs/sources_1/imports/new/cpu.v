`timescale 1ns / 1ps

// cpu就是按照电路图连线，组合各个组件的过程
module cpu(
    input clk,
    input rst
    );
    
    // pc
    wire pc_jmp;
    wire pc_br;
    wire [25: 0] pc_tgt;
    wire [15: 0] pc_off;
    wire [31: 0] pc_nxt;
    
    pc pc(
        .clk(clk),
        .rst(rst),
        
        .pc_jmp(pc_jmp),
        .pc_br(pc_br),
        .pc_tgt(pc_tgt),
        .pc_off(pc_off),
        
        .pc_nxt(pc_nxt)
    );
    
    // insMem
    wire [31: 0] inst;
    insMem insMem(
        .clk(clk),
        .rst(rst),
        
        ._addr(pc_nxt),
        
        .idata(inst)
    );
    
    // ctrl
    wire sel_rt_rd, sel_rs_sa, sel_imm_rt, sel_alu_dm;
    wire [3: 0] alu_ctrl;
    wire reg_we, dm_we;
    wire [1: 0] br_we;
    
    ctrl ctrl(
        .opcode(inst[31: 26]),
        .func(inst[5: 0]),
        
        .sel_rt_rd(sel_rt_rd),
        .sel_rs_sa(sel_rs_sa),
        .sel_imm_rt(sel_imm_rt), 
        .sel_alu_dm(sel_alu_dm), 
        .alu_ctrl(alu_ctrl),
        
        .reg_we(reg_we),
        .dm_we(dm_we),
        .br_we(br_we)
    );
    
    // signExt
    wire [31: 0] imm_ext;
    
    signExt signExt(
        .imm(inst[15: 0]),
        
        .imm_ext(imm_ext)
    );
    
    // brUnit
    wire [31: 0] rs_data, rt_data;
    
    brUnit brUnit(
        .clk(clk),
        .rst(rst),
        
        .rs_data(rs_data),
        .rt_data(rt_data),
        .inst(inst),
        .pc4(pc_nxt[31: 28]),
        .br_we(br_we),
        
        .pc_jmp(pc_jmp),
        .pc_br(pc_br),
        .pc_tgt(pc_tgt),
        .pc_off(pc_off)
    );
    
    // regFile
    wire [4: 0] wb_addr;
    wire [31: 0] wb_data;
    
    regFile regFile(
        .clk(clk),
        .rst(rst),
        
        .reg_we(reg_we),
        .rs_addr(inst[25: 21]),
        .rt_addr(inst[20: 16]),
        .wb_addr(wb_addr),
        .wb_data(wb_data),
        
        .rs_data(rs_data),
        .rt_data(rt_data)
    );
    
    // alu
    wire [31: 0] num1, num2, ans;
    
    alu alu(
        .clk(clk),
        .rst(rst),
        
        .alu_ctrl(alu_ctrl),
        .num1(num1),
        .num2(num2),
        
        .ans(ans)
    );
    
    // dataMem
    wire [31: 0] dm_data;
    
    dataMem dataMem(
        .clk(clk),
        .rst(rst),
        
        .we(dm_we),
        ._addr(ans),
        .wdata(rt_data),
        
        .rdata(dm_data)
    );
    
    // mux_rt_rd
    mux5 mux_rt_rd(
        .in1(inst[20: 16]),
        .in2(inst[15: 11]),
        .sel(sel_rt_rd),
        
        .out(wb_addr)
    );
    
    // mux_rs_sa
    mux32 mux_rs_sa(
        .in1(rs_data),
        .in2(imm_ext),
        .sel(sel_rs_sa),
        
        .out(num1)
    );
    
    // mux_imm_rt
    mux32 mux_imm_rt(
        .in1(imm_ext),
        .in2(rt_data),
        .sel(sel_imm_rt),
        
        .out(num2)
    );
    
    // mux_alu_dm
    mux32 mux_alu_dm(
        .in1(ans),
        .in2(dm_data),
        .sel(sel_alu_dm),
        
        .out(wb_data)
    ); 
    
endmodule
