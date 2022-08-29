`timescale 1ns / 1ps

module signExt(
    input [15: 0] imm,
    
    output [31: 0] imm_ext
    );
    
    assign imm_ext = {{16{imm[15]}}, imm[15: 0]};           // ´ø·ûºÅÀ©Õ¹
    
endmodule
