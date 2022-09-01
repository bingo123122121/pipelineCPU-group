`timescale 1ns / 1ps

module buffer0(                                         // 取指令部件
    input clk,
    input rst,
    
    input [1: 0] _br_we, //分支模块使能
    input [31: 0] _rs_data, //rs数据
    input [31: 0] _rt_data, //rt数据
//    input [3: 0] _pc4,
    input [25: 0] _inst_addr, //指令的分支地址
    input pause, //暂停信号
//    input [31: 0] _sel_4_0,
    
    output [31: 0] inst_val //读出的指令
//    output [31: 0] pc_val //pc值
    );
    
    reg [1: 0] br_we;
    reg [31: 0] rs_data, rt_data;
    wire [31: 0] pc_val;
//    reg [3: 0] pc4;
    reg [25: 0] inst_addr;
//    reg [31: 0] sel_4_0;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            br_we <= 2'b0;
            rs_data <= 32'b0;
            rt_data <= 32'b0;
//            pc4 <= 4'b0;
            inst_addr <= 25'b0;
//            sel_4_0 <= 32'b0;
        end
        else begin
            br_we <= _br_we;
            rs_data <= _rs_data;
            rt_data <= _rt_data;
//            pc4 <= pc_val[31:28];
            inst_addr <= _inst_addr;
//            sel_4_0 <= _sel_4_0;
        end
    end
    
    // branch unit
    wire pc_jmp; //jmp使能
    wire pc_br; //br使能
    wire [25: 0] pc_tgt;
    wire [15: 0] pc_off;
    
    brUnit brUnit(
        .clk(clk),
        .rst(rst),
        
        .rs_data(rs_data),
        .rt_data(rt_data),
        .inst_addr(inst_addr),
        .pc4(pc_val[31:28]),
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
        .pause(pause),
//        .sel_4_0(sel_4_0),
        
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
