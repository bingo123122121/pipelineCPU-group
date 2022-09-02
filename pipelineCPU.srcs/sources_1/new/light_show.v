`timescale 1ns / 1ps

module light_show(
    input clk,//系统时钟
    input rst_n,//复位信号
    input [7:0] show_num,//输入8-bit数据
    output [6:0] o_led,//七段数码管LED信号
    output [1:0] o_dx//七段数码管段选信号
    );
//    parameter C_COUNTER_NUM=1000000;//计数器峰值,上板
    parameter C_COUNTER_NUM=2;//计数器峰值，仿真
    reg[3:0] R_temp;//当前显示的4-bit数据寄存器
    reg[1:0] R_dx_temp;//段选信号寄存器
    reg[32:0] R_counter;//计数器寄存器
    
    //交替显示
    always@(posedge clk or posedge rst_n)
    begin
        if(rst_n)
            begin//复位处理
                R_dx_temp <= 2'b01;  //默认段选信号
                R_temp <= 0;
                R_counter <= 0;
            end
        else if(R_dx_temp == 2'b01 && R_counter >= C_COUNTER_NUM)
            begin
                R_temp <= show_num[7:4];
                R_dx_temp <= 2'b10;
                R_counter <= 0;
            end
        else if(R_dx_temp == 2'b10 && R_counter >= C_COUNTER_NUM)
            begin
                R_temp <= show_num[3:0];
                R_dx_temp <= 2'b01;
                R_counter <= 0;           
            end
        else begin//计数器自增
            R_counter <= R_counter+1;
        end
    end
    
    //led端信号
    assign o_led[0]=(R_temp==4'b0000||R_temp==4'b0001||R_temp==4'b0111||R_temp==4'b1100)?0:1;
    assign o_led[1]=(R_temp==4'b0001||R_temp==4'b0010||R_temp==4'b0011||R_temp==4'b0111||R_temp==4'b1101)?0:1;
    assign o_led[2]=(R_temp==4'b0001||R_temp==4'b0011||R_temp==4'b0100||R_temp==4'b0101||R_temp==4'b0111||R_temp==4'b1001)?0:1;
    assign o_led[3]=(R_temp==4'b0001||R_temp==4'b0100||R_temp==4'b0111||R_temp==4'b1010||R_temp==4'b1111)?0:1;
    assign o_led[4]=(R_temp==4'b0010||R_temp==4'b1100||R_temp==4'b1110||R_temp==4'b1111)?0:1;
    assign o_led[5]=(R_temp==4'b0101||R_temp==4'b0110||R_temp==4'b1011||R_temp==4'b1100||R_temp==4'b1110||R_temp==4'b1111)?0:1;
    assign o_led[6]=(R_temp==4'b0001||R_temp==4'b0100||R_temp==4'b1011||R_temp==4'b1101)?0:1;
    
    //段选信号
    assign o_dx = R_dx_temp;
endmodule
