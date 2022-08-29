`timescale 1ns / 1ps

module mux5(                        // ѡ������6λ�źŵĶ�·ѡ������0ѡin1��1ѡin2
    input [4: 0] in1, in2,
    input sel,
    
    output [4: 0] out
    );
    
    assign out = (sel == 1'b0) ? in1 : in2;
    
endmodule

module mux32(                       // ѡ������32λ�źŵĶ�·ѡ������0ѡin1��1ѡin2
    input [31: 0] in1, in2,
    input sel,
    
    output [31: 0] out
    );
    
    assign out = (sel == 1'b0) ? in1 : in2;
    
endmodule
