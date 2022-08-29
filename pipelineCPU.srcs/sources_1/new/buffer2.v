`timescale 1ns / 1ps

module buffer2(                 // 指令执行部件
    input clk,
    input rst,
    
    input _reg_we,
    input _dm_we,
    input _sel_rs_sa,
    input _sel_imm_rt,
    input _sel_alu_dm,
    input [3: 0] _alu_ctrl,
    input [31: 0] _imm_ext,
    input [31: 0] _rs_data,
    input [31: 0] _rt_data,
    input [4: 0] _reg_wa,
    
    output reg_we_,
    output dm_we_,
    output sel_alu_dm_,
    output [31: 0] alu_ans,
    output [31: 0] rt_data_,
    output [4: 0] reg_wa_
    );
    
    reg reg_we, dm_we;
    reg sel_rs_sa, sel_imm_rt, sel_alu_dm;
    reg [3: 0] alu_ctrl;
    reg [31: 0] imm_ext, rs_data, rt_data;
    reg [4: 0] reg_wa;
    
    wire [31: 0] num1, num2;
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            reg_we <= 1'b0;
            dm_we <= 1'b0;
            sel_rs_sa <= 1'b0;
            sel_imm_rt <= 1'b0;
            sel_alu_dm <= 1'b0;
            alu_ctrl <= 4'b0;
            imm_ext <= 32'b0;
            rs_data <= 32'b0;
            rt_data <= 32'b0;
            reg_wa <= 5'b0;
        end
        else begin
            reg_we <= _reg_we;
            dm_we <= _dm_we;
            sel_rs_sa <= _sel_rs_sa;
            sel_imm_rt <= _sel_imm_rt;
            sel_alu_dm <= _sel_alu_dm;
            alu_ctrl <= _alu_ctrl;
            imm_ext <= _imm_ext;
            rs_data <= _rs_data;
            rt_data <= _rt_data;
            reg_wa <= _reg_wa;
        end
    end
    
    assign reg_we_ = reg_we;
    assign dm_we_ = dm_we;
    assign sel_alu_dm_ = sel_alu_dm;
    assign rt_data_ = rt_data;
    assign reg_wa_ = reg_wa;
    
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
    
    alu alu(
        .clk(clk),
        .rst(rst),
        
        .alu_ctrl(alu_ctrl),
        .num1(num1),
        .num2(num2),
        
        .ans(alu_ans)
    );
    
    
endmodule
