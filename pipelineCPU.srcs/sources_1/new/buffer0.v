`timescale 1ns / 1ps

module buffer0(                                         // 取指令部件
    input clk,
    input rst,
    
    input [1: 0] _br_we,
    input [31: 0] _rs_data,
    input [31: 0] _rt_data,
    input [3: 0] _pc4,
    input [31: 0] _inst,
    input [31: 0] _sel_4_0,
    
    output [31: 0] inst_val,
    output [31: 0] pc_val
    );
    
    reg [1: 0] br_we;
    reg [31: 0] rs_data, rt_data;
    reg [3: 0] pc4;
    reg [31: 0] inst;
    reg [31: 0] sel_4_0;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            br_we <= 2'b0;
            rs_data <= 32'b0;
            rt_data <= 32'b0;
            pc4 <= 4'b0;
            inst <= 26'b0;
            sel_4_0 <= 32'b0;
        end
        else begin
            br_we <= _br_we;
            rs_data <= _rs_data;
            rt_data <= _rt_data;
            pc4 <= _pc4;
            inst <= _inst;
            sel_4_0 <= _sel_4_0;
        end
    end
    
    // branch unit
    wire pc_jmp;
    wire pc_br;
    wire [25: 0] pc_tgt;
    wire [15: 0] pc_off;
    
    brUnit brUnit(
        .clk(clk),
        .rst(rst),
        
        .rs_data(rs_data),
        .rt_data(rt_data),
        .inst(inst),
        .pc4(pc4),
        .br_we(br_we),
        
        .pc_jmp(pc_jmp),
        .pc_br(pc_br),
        .pc_tgt(pc_tgt),
        .pc_off(pc_off)
    );
    
    // pc
    pc pc(
        .clk(clk),
        .rst(rst),
        
        .pc_jmp(pc_jmp),
        .pc_br(pc_br),
        .pc_tgt(pc_tgt),
        .pc_off(pc_off),
        .sel_4_0(sel_4_0),
        
        .pc_nxt(pc_val)
    );
    
    // instruction memory
    insMem insMem(
        .clk(clk),
        .rst(rst),
        
        ._addr(pc_val),
        
        .idata(inst_val)
    );
    
endmodule
