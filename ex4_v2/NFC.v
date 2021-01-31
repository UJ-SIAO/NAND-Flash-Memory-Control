`timescale 1ns/100ps
module NFC(clk, rst, done, F_IO_A, F_CLE_A, F_ALE_A, F_REN_A, F_WEN_A, F_RB_A, F_IO_B, F_CLE_B, F_ALE_B, F_REN_B, F_WEN_B, F_RB_B);

input        clk;
input        rst;
output reg   done;
inout  		 [7:0] F_IO_A;
output reg   F_CLE_A;
output reg   F_ALE_A;
output reg   F_REN_A;
output reg   F_WEN_A=1;
input        F_RB_A;
inout  		 [7:0] F_IO_B;
output reg   F_CLE_B;
output reg   F_ALE_B;
output reg   F_REN_B;
output reg   F_WEN_B=1;
input        F_RB_B;

reg isout_A;
reg isout_B;
reg [7:0]F_OUT_A;
reg [7:0]F_OUT_B;
reg [9:0]conter;
reg [9:0]conter_B;
reg [9:0]conter_initi;
reg [9:0]conter_B__initi;
reg [7:0]recive_data[31:0];
reg [7:0]recive_data_cnt;
reg [7:0]recive_data_cnt_B;

integer i;

assign	F_IO_A = isout_A ? F_OUT_A : 8'bz;
assign	F_IO_B = isout_B ? F_OUT_B : 8'bz;

always@(posedge clk or posedge rst) begin
	if(rst)
		conter	<= 0;
	else begin
		if(F_RB_A)begin
			if(conter == 100)
				conter <= 100;
			else
				conter <= conter + 1 ;
		end
		else 
			conter <= conter;
	end
end

always@(posedge clk or posedge rst) begin //B------------
	if(rst)
		conter_B	<= 0;
	else begin
		if(F_RB_B)begin
			if(conter_B == 100)
				conter_B <= 100;
			else if (recive_data_cnt == 32)
				conter_B <= conter_B + 1 ;
		end
		else 
			conter_B <= conter_B;
	end
end

always@(posedge clk or posedge rst) begin
	if(rst)
		conter_initi	<= 0;
	else begin
		if(!F_RB_A)begin
			if(conter_initi == 2)
				conter_initi <= 100;
			else
				conter_initi <= conter_initi + 1 ;
		end
		else 
			conter_initi <= 100;
	end
end

always@(posedge clk or posedge rst) begin //B------------
	if(rst)
		conter_B__initi	<= 100;
	else begin
		if(!F_RB_B && recive_data_cnt >= 31)begin
			if(conter_B__initi == 100)
				conter_B__initi <= 0;
			else 
				conter_B__initi <= conter_B__initi + 1 ;
		end
		else 
			conter_B__initi <= conter_B__initi;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		F_CLE_A	<= 0;
	else begin
		if(F_RB_A)begin
			if(conter == 0)
				F_CLE_A <= 1;
			else if (conter == 2)
				F_CLE_A <= 0;
		end
		else begin
			if(conter_initi == 0)
				F_CLE_A <= 1;
			else if (conter_initi == 2)
				F_CLE_A <= 0;
		end
	end
end

always@(posedge clk or posedge rst)begin //B------------
	if(rst)
		F_CLE_B	<= 0;
	else begin
		if(F_RB_B)begin
			if( conter_B == 1 || conter_B == 2 )
				F_CLE_B <= 1;
			/*else if (conter_B == 8'h4C)
				F_CLE_B <= 0;*/
			else if (recive_data_cnt_B == 32 )
				F_CLE_B <= 1;
			else if (conter_B__initi >= 2)
				F_CLE_B <= 0;
		end
		else begin
			if(conter_B__initi == 0)
				F_CLE_B <= 1;
			else if (conter_B__initi == 2 && recive_data_cnt_B == 32)
				F_CLE_B <= 1;
			else if (conter_B__initi == 3 && recive_data_cnt_B == 32)
				F_CLE_B <= 1;
			else if (conter_B__initi >= 2)
				F_CLE_B <= 0;
		end
	end
end

always@(posedge clk or posedge rst) begin
	if(rst)
		isout_A <= 1 ;
	else begin
		if(F_CLE_A)
			isout_A <= 1;
		else if (conter == 8)
			isout_A <= 0;
	end
end

always@(posedge clk or posedge rst) begin //B------------
	if(rst)
		isout_B <= 1 ;
	else begin
		isout_B <= 1;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		F_ALE_A <= 0;
	else begin
		if(conter >= 1 && conter <= 8)
			F_ALE_A <= 1;
		else if(conter_initi >= 2 && conter_initi <= 9)
			F_ALE_A <= 1;
		else
			F_ALE_A <= 0;
	end
end

always@(posedge clk or posedge rst)begin //B------------
	if(rst)
		F_ALE_B <= 0;
	else begin
		if(conter_B >= 3 && conter_B <= 8)
			F_ALE_B <= 1;
		/*else if(conter_B__initi >= 2 && conter_B__initi <= 8)
			F_ALE_B <= 1;*/
		else
			F_ALE_B <= 0;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		F_WEN_A <= 1;
	else begin
		if(!isout_A)
			F_WEN_A <= 1;
		else if(conter_initi == 0)
			F_WEN_A <= 0;
		else if(conter_initi == 1)
			F_WEN_A <= 1;
		else if(conter == 0 || conter == 2 || conter == 4 || conter == 6)
			F_WEN_A <= 0;
		else if(conter == 1 || conter == 3 || conter == 5 || conter == 7)
			F_WEN_A <= 1;
		else 
			F_WEN_A <= 1;
	end
end

always@(posedge clk or posedge rst)begin //B------------
	if(rst)
		F_WEN_B <= 1;
	else begin
		if(conter_B >= 3 && recive_data_cnt_B <= 31 && F_RB_B)
			F_WEN_B <= ~F_WEN_B;
		else if (recive_data_cnt_B == 32 && conter_B == 8'h4B)
			F_WEN_B <= 0;
		else if (recive_data_cnt_B == 32 && conter_B == 8'h4C)
			F_WEN_B <= 1;
		else if(conter_B == 1 || conter_B == 3)
			F_WEN_B <= 0 ;
		else if(conter_B == 2 )
			F_WEN_B <= 1 ;
		else if(conter_B__initi == 0)
			F_WEN_B <= 0;
		else if(conter_B__initi == 1)
			F_WEN_B <= 1;
		else
			F_WEN_B <= 1;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		F_OUT_A <= 0;
	else begin
			if (conter_initi == 0)
				F_OUT_A <= 8'hFF;
			else if(conter == 0 && F_RB_A)
				F_OUT_A <= 0;
			else if (conter == 2 && F_RB_A)
				F_OUT_A <= 0;
			else if (conter == 4 && F_RB_A)
				F_OUT_A <= 0;
			else if (conter == 6 && F_RB_A)
				F_OUT_A <= 0;
			else if (conter == 8 && F_RB_A)
				F_OUT_A <= 0;
	end
end

always@(posedge clk or posedge rst)begin //B------------
	if(rst)
		F_OUT_B <= 0;
	else begin
		if(conter_B >= 9 && recive_data_cnt_B != 32)
			F_OUT_B <= recive_data[recive_data_cnt_B];
		else if (recive_data_cnt_B == 32)
			F_OUT_B <= 8'h10;
		else if (conter_B__initi == 0)
			F_OUT_B <= 8'hFF;
		else if(conter_B == 1 && F_RB_A)
			F_OUT_B <= 8'h80;
		else if (conter_B == 3 && F_RB_A)
			F_OUT_B <= 0;
		else if (conter_B == 5 && F_RB_A)
			F_OUT_B <= 0;
		else if (conter_B == 7 && F_RB_A)
			F_OUT_B <= 0;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		F_REN_A <= 1;
	else begin
		if(conter >= 10 && recive_data_cnt <=31 )
			F_REN_A <= ~ F_REN_A;
		else if (recive_data_cnt >31)
			F_REN_A <= 1;
	end
end

always@(posedge clk or posedge rst)begin //B------------
	if(rst)
		F_REN_B <= 1;
	else begin
		F_REN_B <= 1;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		recive_data_cnt<=0;
	else begin
		if(!F_REN_A && recive_data_cnt <=31)
			recive_data_cnt <= recive_data_cnt +1;
		else
			recive_data_cnt <= recive_data_cnt;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		for(i=0;i<31;i=i+1)
			recive_data[i] <= 0;
	end
	else begin
		if(F_RB_A)begin
			if(recive_data_cnt <=31)
				recive_data[recive_data_cnt] <=  F_IO_A ;
		end
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		recive_data_cnt_B<=0;
	else begin
		if(conter_B >= 9  && recive_data_cnt_B <= 31 && !F_WEN_B)
			recive_data_cnt_B <= recive_data_cnt_B +1;
		else if(recive_data_cnt_B >31)
			recive_data_cnt_B <= 32;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)
		done<=0;
	else begin
		if(F_RB_B && recive_data_cnt_B == 32 && conter_B == 8'h50)
			done <= 1;
		else
			done <= 0;
	end
end

endmodule
