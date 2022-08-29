`timescale 1ns / 1ps

module buffer3(                          // 数据存储器取数部件
    input clk,
    input rst,
    
    input _reg_we,
    input _dm_we,
    input _sel_alu_dm,
    input [31: 0] _alu_ans,
    input [31: 0] _rt_data,
    input [4: 0] _reg_wa,
    
    output reg_we_,
    output sel_alu_dm_,
    output [31: 0] dm_data,
    output [31: 0] alu_ans_,
    output [4: 0] reg_wa_
    );
    
    reg reg_we, dm_we, sel_alu_dm;
    reg [31: 0] alu_ans, rt_data;
    reg [4: 0] reg_wa;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_we <= 1'b0;
            dm_we <= 1'b0;
            sel_alu_dm <= 1'b0;
            alu_ans <= 32'b0;
            rt_data <= 32'b0;
            reg_wa <= 5'b0;
        end
        else begin
            reg_we <= _reg_we;
            dm_we <= _dm_we;
            sel_alu_dm <= _sel_alu_dm;
            alu_ans <= _alu_ans;
            rt_data <= _rt_data;
            reg_wa <= _reg_wa;
        end
    end
    
    assign reg_we_ = reg_we;
    assign sel_alu_dm_ = sel_alu_dm;
    assign alu_ans_ = alu_ans;
    assign reg_wa_ = reg_wa;
    
    dataMem dataMem(
        .clk(clk),
        .rst(rst),
        
        .we(dm_we),
        ._addr(alu_ans),
        .wdata(rt_data),
        
        .rdata(dm_data)
    );
    
    
endmodule
