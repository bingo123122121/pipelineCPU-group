`timescale 1ns / 1ps

module regFile(
    input clk,
    input rst,
    
    input reg_we,                   // ¼Ä´æÆ÷¶ÑĞ´Ê¹ÄÜ
    input [4: 0] rs_addr,           // rs¼Ä´æÆ÷µØÖ·
    input [4: 0] rt_addr,           // rt¼Ä´æÆ÷µØÖ·
    input [4: 0] wb_addr,           // ´ıĞ´ÈëµØÖ·
    input [31: 0] wb_data,          // ´ıĞ´ÈëÊı¾İ
    
    output [31: 0] rs_data,         // rs¼Ä´æÆ÷Öµ
    output [31: 0] rt_data          // rt¼Ä´æÆ÷Öµ
    );
    
    reg [31: 0] gpr[31: 0];         // ¼Ä´æÆ÷¶Ñ
    
    integer i;
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            for(i = 0; i < 32; i = i + 1)
                gpr[i] <= 0;
        end
        else if(reg_we) gpr[wb_addr] <= wb_data;
    end
    
    assign rs_data = gpr[rs_addr];
    assign rt_data = gpr[rt_addr];
    
endmodule
