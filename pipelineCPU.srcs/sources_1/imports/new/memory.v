`timescale 1ns / 1ps

module insMem(
    input clk,
    input rst,
    
    input [31: 0] _addr,        // ��ȡ��ָ���ַ�����õ�8λ
    
    output [31: 0] idata        // ������ָ��
    );
    
    reg [7: 0] imem[255: 0];    // ָ��洢��
    integer i;

    
    initial begin               // �������ڷ���
        $readmemh("C:/Users/Dune/Desktop/xiaoxueqi/pipelineCPU-group/test/shangban.mem", imem);
    end
    
    wire [7: 0] addr = _addr[7: 0];
    assign idata = {imem[addr+3], imem[addr+2], imem[addr+1], imem[addr]};          // С�˷�������
    
    
    
endmodule

module dataMem(
    input clk,
    input rst,
    input we,                   // дʹ��
    
    input [31: 0] _addr,        // ��ȡ�����ݵ�ַ�����õ�8λ
    input [31: 0] wdata,        // ��д����
    
    output [31: 0] rdata        // ��������
    );
    
    reg [7: 0] dmem[255: 0];    // ���ݴ洢��
    
    integer i;
    initial begin               // �������ڷ���
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
