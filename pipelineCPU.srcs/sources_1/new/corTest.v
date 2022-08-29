`timescale 1ns / 1ps

module corTest(
    input [31: 0] inst,
    input [31: 0] pc,
    
    output [31: 0] inst_nxt,
    output [31: 0] sel_4_0,
    output [3: 0] pc4
    );
    
    assign inst_nxt = inst;
    assign sel_4_0 = 32'h4;
    assign pc4 = pc[31: 28];
    
endmodule
