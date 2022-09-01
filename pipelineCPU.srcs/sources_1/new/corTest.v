`timescale 1ns / 1ps

module corTest(
    input clk,
    input rst,
    
    input [31:0] inst, //��ǰ�����ָ��
//    input [4:0] ins_type, // ָ����
    input [4:0] wb_addr, // ��ǰָ���д�ص�ַ
    input [31:0] rs_data,
    input [31:0] rt_data,
//    input [4:0] rs_addr, // rs�Ĵ�����ַ
//    input [4:0] rt_addr, // rt�Ĵ�����ַ
//    input [31: 0] pc, // ��ǰ�����pcֵ
 
    output pause, //ֹͣ�ź�   
    output drop
//    output [3: 0] pc4, //pc��4λ
//    output [31: 0] sel_4_0, // ѡ����һ��pc�ƶ���ֵ��4/0
    );
    
    wire [5:0] opcode = inst[31:26];
    wire [5:0] func = inst[5:0];
    
    wire [4:0] rs_addr = inst[25:21]; // rs�Ĵ�����ַ
    wire [4:0] rt_addr = inst[20:16]; // rt�Ĵ�����ַ
//    wire [4:0] wb_addr; // rd�Ĵ�����ַ(�����)    
    
    reg [4:0] addr_buff1; // ��һ��ָ���д�ص�ַ
    reg [4:0] addr_buff2; // ������ָ���д�ص�ַ
    reg [4:0] addr_buff3; // ������ָ���д�ص�ַ

//    //�ж�д��reg�ĵ�ַ��rt����rd
//    assign wb_addr = (opcode == 6'b001000 || opcode == 6'b001100 || opcode == 6'b001101 || 
//                        opcode == 6'b001110 ||opcode == 6'b001111 || opcode == 6'b100011) ? inst[20:16] ://д��rt
//                    (opcode == 6'b000000) ? inst[15:11] //д��rd
//                    :5'h0; //����д��
    
    //����ǰ����ָ���д�ص�ַ
    always @(posedge clk or negedge rst) begin
        if (!rst) begin //��ʼ��
            addr_buff1 <= 0;
            addr_buff2 <= 0;
            addr_buff3 <= 0;
        end
        else begin
            addr_buff3<= addr_buff2;
            addr_buff2 <= addr_buff1;
            addr_buff1 <= wb_addr;
        end
    end
    
    // ö��������Ե�ָ���ͣ��ˮ��
    assign pause = (opcode == 6'b001000 || opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110 ||opcode == 6'b100011) ? //ֻ��rs
                    ( ((addr_buff1 == rs_addr || addr_buff2 == rs_addr || addr_buff3 == rs_addr) && rs_addr != 0) ? 1 : 0 ) : 
                   (opcode == 6'b000000 && (func == 6'b000000 || func == 6'b000010)) ? //ֻ��rt
                    ( ((addr_buff1 == rt_addr || addr_buff2 == rt_addr || addr_buff3 == rt_addr) && rt_addr != 0) ? 1 : 0 ) :
                   (opcode == 6'b101011 || opcode == 6'b000100 ||  
                   opcode == 6'b000000 && (func == 6'b100000 || func == 6'b100010 || func == 6'b100100 || func == 6'b100101 ||
                                            func == 6'b100110 || func == 6'b100111 || func == 6'b101010)) ? 
                    ( ((addr_buff1 == rs_addr || addr_buff2 == rs_addr || addr_buff3 == rs_addr) && rs_addr != 0) ? 1 : 
                     ( ((addr_buff1 == rt_addr || addr_buff2 == rt_addr || addr_buff3 == rt_addr) && rt_addr != 0) ? 1 : 0 )) : 0;//��rs��rt
    //�������תָ����ˢ��ˮ��
    assign drop = ( opcode == 6'b000010 || (opcode == 6'b000100 && (rs_data == rt_data)) ) ? 1 : 0;
    
//    assign sel_4_0 = pause ? 32'h4 : 32'h0;
//    assign pc4 = pc[31: 28];
endmodule
