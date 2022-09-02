`timescale 1ns / 1ps

module testbench(

    );
    
    reg clk;
    reg rst;
    wire [6:0] led;
    wire [1:0] dx;
    
    initial begin
        clk = 0;
        rst = 1;
        
        #10 rst = 0;
                
    end
    
    always #10 clk = ~clk;
    
//    cpu cpu(
//        .clk(clk),
//        .rst(rst)
//    );

    light_control _light_control(
        .clk(clk),
        .rst_n(rst),
        
        .led(led),
        .dx(dx)
    );
    
endmodule
