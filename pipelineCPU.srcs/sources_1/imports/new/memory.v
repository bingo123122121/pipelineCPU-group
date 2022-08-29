`timescale 1ns / 1ps

module insMem(
    input clk,
    input rst,
    
    input [31: 0] _addr,        // 仅用低8位
    
    output [31: 0] idata
    );
    
    reg [7: 0] imem[255: 0];
    integer i;

    
    initial begin
        $readmemh("C:/Users/bu123/Desktop/1.mem", imem);

    end
    
    wire [7: 0] addr = _addr[7: 0];
    assign idata = {imem[addr+3], imem[addr+2], imem[addr+1], imem[addr]};
    
    
    
endmodule

module dataMem(
    input clk,
    input rst,
    input we,
    
    input [31: 0] _addr,        // 仅用低8位
    input [31: 0] wdata,    
    
    output [31: 0] rdata
    );
    
    reg [7: 0] dmem[255: 0];
    
    integer i;
    initial begin
        for(i=0; i<256; i = i + 1) dmem[i] = 8'b0;
    end
    
    wire [7: 0] addr = _addr[7: 0];
    assign rdata = {dmem[addr+3], dmem[addr+2], dmem[addr+1], dmem[addr]};
    
    always @(posedge clk) begin
        if (we) begin
            dmem[addr] <= wdata[7: 0];
            dmem[addr+1] <= wdata[15: 8];
            dmem[addr+2] <= wdata[23: 16];
            dmem[addr+3] <= wdata[31: 24];
        end
    end
    
endmodule
