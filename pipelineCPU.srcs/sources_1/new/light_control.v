`timescale 1ns / 1ps
module light_control(
    input clk,//ϵͳʱ��
    input rst_n,//��λ�ź�
    
    output [6:0] led,//�߶������LED�ź�
    output [1:0] dx//�߶�����ܶ�ѡ�ź�
    );
                   
    reg[7:0] R_num; //��ʾ���ּĴ���
    wire [31: 0] data;
    wire [3:0] shiwei, gewei;
//    assign shiwei = (data[1]*16 + data[0])/10;
    assign shiwei = data/10;
    assign gewei = data%10;

     always@(posedge clk or posedge rst_n)
     begin
        if(rst_n)begin//��λ����
            R_num <= 0;
        end
        else begin
            case (shiwei)
            0: R_num[7:4] <= 4'b0000;
            1: R_num[7:4] <= 4'b0001;
            2: R_num[7:4] <= 4'b0010;
            3: R_num[7:4] <= 4'b0011;
            4: R_num[7:4] <= 4'b0100;
            5: R_num[7:4] <= 4'b0101;
            6: R_num[7:4] <= 4'b0110;
            7: R_num[7:4] <= 4'b0111;
            8: R_num[7:4] <= 4'b1000;
            9: R_num[7:4] <= 4'b1001;
            endcase
            case (gewei)
            0: R_num[3:0] <= 4'b0000;
            1: R_num[3:0] <= 4'b0001;
            2: R_num[3:0] <= 4'b0010;
            3: R_num[3:0] <= 4'b0011;
            4: R_num[3:0] <= 4'b0100;
            5: R_num[3:0] <= 4'b0101;
            6: R_num[3:0] <= 4'b0110;
            7: R_num[3:0] <= 4'b0111;
            8: R_num[3:0] <= 4'b1000;
            9: R_num[3:0] <= 4'b1001;
            endcase
        end
    end                    
       
       light_show _light_show(
       .clk    (clk),
       .rst_n   (rst_n),
       .show_num  (R_num),
       
       .o_led      (led),
       .o_dx       (dx)
       );
       
       cpu _cpu(
       .clk(clk),
       .rst(!rst_n),
       
       .output_data(data)
       );
endmodule
