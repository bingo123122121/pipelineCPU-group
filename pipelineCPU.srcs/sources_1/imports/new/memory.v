`timescale 1ns / 1ps

module insMem(
    input clk,
    input rst,
    
    input [31: 0] _addr,        // 读取的指令地址，仅用低8位
    
    output [31: 0] idata        // 读出的指令
    );
    
    reg [7: 0] imem[255: 0];    // 指令存储器
    integer i;

    
    initial begin               // 仅可用于仿真
        $readmemh("C:/Users/Dune/Desktop/xiaoxueqi/pipelineCPU-group/test/shangban.mem", imem);
    end
    
    wire [7: 0] addr = _addr[7: 0];
    assign idata = {imem[addr+3], imem[addr+2], imem[addr+1], imem[addr]};          // 小端方案读出
    
    
    
endmodule

module dataMem(
    input clk,
    input rst,
    input we,                   // 写使能
    
    input [31: 0] _addr,        // 读取的数据地址，仅用低8位
    input [31: 0] wdata,        // 待写数据
    
    output [31: 0] rdata        // 读出数据
    );
    
    reg [7: 0] dmem[255: 0];    // 数据存储器
    
    integer i;
    initial begin               // 仅可用于仿真
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
