`timescale 1ns / 1ps

// PC

module pc(
    input clk,
    input rst,
    
    input pc_jmp,               // brUnit输出的jmp信号
    input pc_br,                // brUnit输出的branch信号
    input [25: 0] pc_tgt,       // instruction[25: 0]
    input [15: 0] pc_off,       // instruction[15: 0]
    input [31: 0] sel_4_0,      // 选择+4或+0
    
    output [31: 0] pc_nxt       // 下一条指令的pc值
    );
    
    reg [31: 0] pc_reg;         // PC寄存器
    
    wire [31: 0] pc_ds;
    assign pc_ds = pc_reg + 32'h4;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) pc_reg <= 32'hbfc00000;
        else if(pc_jmp) pc_reg <= {pc_ds[31:28], pc_tgt[25:0], 2'b00};      // pc = pc高4位 拼接 pc_tgt<<2
        else if(pc_br) pc_reg <= pc_ds + (pc_off << 2);                     // pc = pc_off<<2 + pc + 4
        else pc_reg <= pc_ds;                                               // pc = pc + 4
    end
    
    assign pc_nxt = pc_reg;
    
endmodule
