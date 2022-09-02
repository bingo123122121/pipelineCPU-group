`timescale 1ns / 1ps

module regFile(
    input clk,
    input rst,
    
    input reg_we,                   // 寄存器堆写使能
    input [4: 0] rs_addr,           // rs寄存器地址
    input [4: 0] rt_addr,           // rt寄存器地址
    input [4: 0] wb_addr,           // 待写入地址
    input [31: 0] wb_data,          // 待写入数据
    
    output [31: 0] rs_data,         // rs寄存器值
    output [31: 0] rt_data,          // rt寄存器值
    output [31: 0] output_data // reg指定位置的数据（上板时显示）
    );
    
    reg [31: 0] gpr[31: 0];         // 寄存器堆
    
    integer i;
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            for(i = 0; i < 32; i = i + 1)
                gpr[i] <= 0;
        end
        else if(reg_we) gpr[wb_addr] <= wb_data;
    end
    
    wire [31:0] addr0 = 32'h8;
    assign output_data = gpr[addr0];
    
    assign rs_data = gpr[rs_addr];
    assign rt_data = gpr[rt_addr];
    
endmodule
