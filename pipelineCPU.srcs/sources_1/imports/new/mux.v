`timescale 1ns / 1ps

module mux5(                        // 选择两个6位信号的二路选择器，0选in1，1选in2
    input [4: 0] in1, in2,
    input sel,
    
    output [4: 0] out
    );
    
    assign out = (sel == 1'b0) ? in1 : in2;
    
endmodule

module mux32(                       // 选择两个32位信号的二路选择器，0选in1，1选in2
    input [31: 0] in1, in2,
    input sel,
    
    output [31: 0] out
    );
    
    assign out = (sel == 1'b0) ? in1 : in2;
    
endmodule
