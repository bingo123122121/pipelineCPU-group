`timescale 1ns / 1ps

module regFile(
    input clk,
    input rst,
    
    input reg_we,
    input [4: 0] rs_addr,
    input [4: 0] rt_addr,
    input [4: 0] wb_addr,
    input [31: 0] wb_data,
    
    output [31: 0] rs_data,
    output [31: 0] rt_data
    );
    
    reg [31: 0] gpr[31: 0];
    
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
