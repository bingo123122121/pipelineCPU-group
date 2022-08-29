`timescale 1ns / 1ps

module testbench(

    );
    
    reg clk;
    reg rst;
    
    initial begin
        clk = 0;
        rst = 0;

        #10 rst = 1;
                
    end
    
    always #10 clk = ~clk;
    
    cpu cpu(
        .clk(clk),
        .rst(rst)
    );
    
endmodule
