`timescale 1ns / 1ps

module regFile(
    input clk,
    input rst,
    
    input reg_we,                   // �Ĵ�����дʹ��
    input [4: 0] rs_addr,           // rs�Ĵ�����ַ
    input [4: 0] rt_addr,           // rt�Ĵ�����ַ
    input [4: 0] wb_addr,           // ��д���ַ
    input [31: 0] wb_data,          // ��д������
    
    output [31: 0] rs_data,         // rs�Ĵ���ֵ
    output [31: 0] rt_data          // rt�Ĵ���ֵ
    );
    
    reg [31: 0] gpr[31: 0];         // �Ĵ�����
    
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
