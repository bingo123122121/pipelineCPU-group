`timescale 1ns / 1ps

module mux5(
    input [5: 0] in1, in2,
    input sel,
    
    output [5: 0] out
    );
    
    assign out = (sel == 1'b0) ? in1 : in2;
    
endmodule

module mux32(
    input [31: 0] in1, in2,
    input sel,
    
    output [31: 0] out
    );
    
    assign out = (sel == 1'b0) ? in1 : in2;
    
endmodule
