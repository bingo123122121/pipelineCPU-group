`timescale 1ns / 1ps

module buffer0(                                         // ȡָ���
    input clk,
    input rst,
    
    input [1: 0] _br_we, //��֧ģ��ʹ��
    input [31: 0] _rs_data, //rs����
    input [31: 0] _rt_data, //rt����
//    input [3: 0] _pc4,
    input [25: 0] _inst_addr, //ָ��ķ�֧��ַ
    input pause, //��ͣ�ź�
//    input [31: 0] _sel_4_0,
    
    output [31: 0] inst_val //������ָ��
//    output [31: 0] pc_val //pcֵ
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
    wire pc_jmp; //jmpʹ��
    wire pc_br; //brʹ��
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
