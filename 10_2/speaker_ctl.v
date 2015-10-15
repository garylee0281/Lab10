`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:14:50 09/11/2015 
// Design Name: 
// Module Name:    speaker_ctl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module speaker_ctl(
clk, // clock from the crystal
reset, // active low reset
audio_in_left, // left channel audio data input
audio_in_right, // right channel audio data input
audio_appsel, // playing mode selection
audio_sysclk, // control clock for DAC (from crystal)
audio_bck, // bit clock of audio data (5MHz)
audio_ws, // left/right parallel to serial control
audio_data // serial output audio data
    );
input clk,reset;
input [15:0]audio_in_left;
input [15:0]audio_in_right;
output audio_appsel,audio_sysclk,audio_bck,audio_ws,audio_data;
wire clk_5MHz,clk_5_32MHz;
wire audio_data;
reg audio_data_tmp;
wire audio_ws;
reg [15:0]audio_tmp;
wire [3:0]cnt;

always@(posedge clk or negedge reset)
begin
	if(~reset)
	begin
		audio_tmp<=16'h0000;
	end
	else
	begin
		if(audio_ws)
		begin
			audio_tmp<=audio_in_left;
		end
		else
		begin
			audio_tmp<=audio_in_right;
		end
	end
end
/*always@(posedge clk or negedge reset)
begin
	if(~reset)
	begin
		audio_data_tmp<=1'b0;
	end
	else
	begin
		if((audio_tmp>16'h8000)&&(audio_tmp<16'h7FFF))
		begin
			audio_data_tmp<=1'b1;
		end
		else
		begin
			audio_data_tmp<=1'b0;
		end
	end
end*/
always@(*)
begin
	case(cnt[3:0])
	4'd0: audio_data_tmp<= audio_tmp[15];
	4'd1: audio_data_tmp<= audio_tmp[14];
	4'd2: audio_data_tmp<= audio_tmp[13];
	4'd3: audio_data_tmp<= audio_tmp[12];
	4'd4: audio_data_tmp<= audio_tmp[11];
	4'd5: audio_data_tmp<= audio_tmp[10];
	4'd6: audio_data_tmp<= audio_tmp[9];
	4'd7: audio_data_tmp<= audio_tmp[8];
	4'd8: audio_data_tmp<= audio_tmp[7];
	4'd9: audio_data_tmp<= audio_tmp[6];
	4'd10: audio_data_tmp<= audio_tmp[5];
	4'd11: audio_data_tmp<= audio_tmp[4];
	4'd12: audio_data_tmp<= audio_tmp[3];
	4'd13: audio_data_tmp<= audio_tmp[2];
	4'd14: audio_data_tmp<= audio_tmp[1];
	4'd15: audio_data_tmp<= audio_tmp[0];
	endcase
end

assign audio_appsel = 1;
assign audio_sysclk = clk;
assign audio_bck = clk_5MHz;
assign audio_ws = clk_5_32MHz;
assign audio_data = audio_data_tmp;
freq_div_inter_speaker fdis(
	.clk(clk), // global clock input
	.rst_n(reset), // active low reset
	.clk_5MHz(clk_5MHz),
	.clk_5_32MHz(clk_5_32MHz),
	.cnt_m(cnt)
	);


endmodule
