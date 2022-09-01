`timescale 1ns / 1ps

module corTest(
    input clk,
    input rst,
    
    input [31:0] inst, //当前传入的指令
//    input [4:0] ins_type, // 指令编号
    input [4:0] wb_addr, // 当前指令的写回地址
    input [31:0] rs_data,
    input [31:0] rt_data,
//    input [4:0] rs_addr, // rs寄存器地址
//    input [4:0] rt_addr, // rt寄存器地址
//    input [31: 0] pc, // 当前传入的pc值
 
    output pause, //停止信号   
    output drop
//    output [3: 0] pc4, //pc高4位
//    output [31: 0] sel_4_0, // 选择下一次pc移动数值，4/0
    );
    
    wire [5:0] opcode = inst[31:26];
    wire [5:0] func = inst[5:0];
    
    wire [4:0] rs_addr = inst[25:21]; // rs寄存器地址
    wire [4:0] rt_addr = inst[20:16]; // rt寄存器地址
//    wire [4:0] wb_addr; // rd寄存器地址(如果有)    
    
    reg [4:0] addr_buff1; // 上一条指令的写回地址
    reg [4:0] addr_buff2; // 上两条指令的写回地址
    reg [4:0] addr_buff3; // 上三条指令的写回地址

//    //判断写回reg的地址是rt还是rd
//    assign wb_addr = (opcode == 6'b001000 || opcode == 6'b001100 || opcode == 6'b001101 || 
//                        opcode == 6'b001110 ||opcode == 6'b001111 || opcode == 6'b100011) ? inst[20:16] ://写入rt
//                    (opcode == 6'b000000) ? inst[15:11] //写入rd
//                    :5'h0; //无需写入
    
    //更新前几条指令的写回地址
    always @(posedge clk or negedge rst) begin
        if (!rst) begin //初始化
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
    
    // 枚举有相关性的指令，暂停流水线
    assign pause = (opcode == 6'b001000 || opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110 ||opcode == 6'b100011) ? //只读rs
                    ( ((addr_buff1 == rs_addr || addr_buff2 == rs_addr || addr_buff3 == rs_addr) && rs_addr != 0) ? 1 : 0 ) : 
                   (opcode == 6'b000000 && (func == 6'b000000 || func == 6'b000010)) ? //只读rt
                    ( ((addr_buff1 == rt_addr || addr_buff2 == rt_addr || addr_buff3 == rt_addr) && rt_addr != 0) ? 1 : 0 ) :
                   (opcode == 6'b101011 || opcode == 6'b000100 ||  
                   opcode == 6'b000000 && (func == 6'b100000 || func == 6'b100010 || func == 6'b100100 || func == 6'b100101 ||
                                            func == 6'b100110 || func == 6'b100111 || func == 6'b101010)) ? 
                    ( ((addr_buff1 == rs_addr || addr_buff2 == rs_addr || addr_buff3 == rs_addr) && rs_addr != 0) ? 1 : 
                     ( ((addr_buff1 == rt_addr || addr_buff2 == rt_addr || addr_buff3 == rt_addr) && rt_addr != 0) ? 1 : 0 )) : 0;//读rs和rt
    //如果是跳转指令，则冲刷流水线
    assign drop = ( opcode == 6'b000010 || (opcode == 6'b000100 && (rs_data == rt_data)) ) ? 1 : 0;
    
//    assign sel_4_0 = pause ? 32'h4 : 32'h0;
//    assign pc4 = pc[31: 28];
endmodule
