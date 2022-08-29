`timescale 1ns / 1ps

module buffer4(                             // ¼Ä´æÆ÷Ğ´»Ø²¿¼ş
    input clk,
    input rst,
    
    input _reg_we,
    input _sel_alu_dm,
    input [31: 0] _dm_data,
    input [31: 0] _alu_ans,
    input [4: 0] _reg_wa,
    
    output reg_we_,
    output [31: 0] reg_wd,
    output [4: 0] reg_wa_
    );
    
    reg reg_we, sel_alu_dm;
    reg [31: 0] dm_data, alu_ans;
    reg [4: 0] reg_wa;
    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            reg_we <= 1'b0;
            sel_alu_dm <= 1'b0;
            dm_data <= 32'b0;
            alu_ans <= 32'b0;
            reg_wa <= 5'b0;
        end
        else begin
            reg_we <= _reg_we;
            sel_alu_dm <= _sel_alu_dm;
            dm_data <= _dm_data;
            alu_ans <= _alu_ans;
            reg_wa <= _reg_wa;
        end
    end
    
    assign reg_we_ = reg_we;
    assign reg_wa_ = reg_wa;
    
    mux32 mux_alu_dmem(
        .in1(alu_ans),
        .in2(dm_data),
        .sel(sel_alu_dm),
        
        .out(reg_wd)
    );
    
endmodule
