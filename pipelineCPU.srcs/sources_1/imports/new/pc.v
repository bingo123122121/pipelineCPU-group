`timescale 1ns / 1ps

module pc(
    input clk,
    input rst,
    
    input pc_jmp,
    input pc_br,
    input [25: 0] pc_tgt,
    input [15: 0] pc_off,
    
    output [31: 0] pc_nxt
    );
    
    reg [31: 0] pc_reg;
    
    wire [31: 0] pc_ds;
    assign pc_ds = pc_reg + 32'h4;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) pc_reg <= 32'hbfc00000;
        else if(pc_jmp) pc_reg <= {pc_ds[31:28], pc_tgt[25:0], 2'b00};
        else if(pc_br) pc_reg <= pc_ds + (pc_off << 2);
        else pc_reg <= pc_ds;
    end
    
    assign pc_nxt = pc_reg;
    
endmodule
