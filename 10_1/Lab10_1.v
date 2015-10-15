`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:46 09/14/2015 
// Design Name: 
// Module Name:    Lab10_1 
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
module Lab10_1(
button_start,
//button_Re,
//button_Mi,
clk, // clock from crystal
reset, // active low reset
audio_appsel, // playing mode selection
audio_sysclk, // control clock for DAC (from crystal)
audio_bck, // bit clock of audio data (5MHz)
audio_ws, // left/right parallel to serial control
audio_data, // serial output audio data
display,
display_ctl,
);
// I/O declaration
input button_start;
//,button_Re,button_Mi;
input clk; // clock from the crystal
input reset; // active low reset
output audio_appsel; // playing mode selection
output audio_sysclk; // control clock for DAC (from crystal)
output audio_bck; // bit clock of audio data (5MHz)
output audio_ws; // left/right parallel to serial control
output audio_data; // serial output audio data
output [14:0]display;
output [3:0]display_ctl;
//output [15:0]LED;
// Declare internal nodes
wire [15:0] audio_in_left, audio_in_right;

//wire [3:0] level1,level0;//sound level

wire [1:0]ftsd_ctl_en;
wire [3:0]bcd;
wire clk_out;
// Note generation
//Do 153257 Re 136519 Me 121212
reg [19:0]input_sound;
reg [3:0]sound_sel;
always@(posedge clk_out or negedge reset)
begin
	if(~reset)
	begin
		sound_sel<=4'd0;
	end
	else
	begin
		sound_sel<=sound_sel+4'd1;
	end
end 
//153257  136519  121212
always@(posedge clk or negedge reset)
begin
	if(~reset)
	begin
		input_sound<=20'd0;
	end
	else
	begin
		case(sound_sel)
		4'd0:input_sound<=20'd181818;//low la
		4'd1:input_sound<=20'd163265;//low si
		4'd2:input_sound<=20'd153257;//mid do
		4'd3:input_sound<=20'd136519;//mid re
		4'd4:input_sound<=20'd121212;//mid mi
		4'd5:input_sound<=20'd114613;//mid fa
		4'd6:input_sound<=20'd102041;//mid so
		4'd7:input_sound<=20'd90909;//mid la
		4'd8:input_sound<=20'd80972;//mid si
		4'd9:input_sound<=20'd76336;//h do
		4'd10:input_sound<=20'd68027;//h re 
		4'd11:input_sound<=20'd60606;//h mi 
		4'd12:input_sound<=20'd57307;//h fa
		4'd13:input_sound<=20'd51020;//h so
		4'd14:input_sound<=20'd45455;//h la
		4'd15:input_sound<=20'd40486;//h si
		endcase
	end
end

buzzer_control Ung(
.low_clk(clk_out),
.clk(clk), // clock from crystal
.rst_n(reset), // active low reset
.note_div(input_sound), // div for note generation
.audio_left(audio_in_left), // left sound audio
.audio_right(audio_in_right) // right sound audio
//.LED(LED)
);
speaker_ctl Usc(
.clk(clk), // clock from the crystal
.reset(reset), // active low reset
.audio_in_left(audio_in_left), // left channel audio data input
.audio_in_right(audio_in_right), // right channel audio data input
.audio_appsel(audio_appsel), // playing mode selection
.audio_sysclk(audio_sysclk), // control clock for DAC (from crystal)
.audio_bck(audio_bck), // bit clock of audio data (5MHz)
.audio_ws(audio_ws), // left/right parallel to serial control
.audio_data(audio_data) // serial output audio data
);
//display
freq_divider fd(
	.clk_out(clk_out),
	.clk_ctl(ftsd_ctl_en), // divided clock output for scan freq
	.clk(clk), // global clock input
	.rst_n(reset) // active low reset
	);
scanf sf(
   .ftsd_ctl(display_ctl), // ftsd display control signal 
	.ftsd_in(bcd), // output to ftsd display
	.in0(4'd0), // 1st input
	.in1(4'd0), // 2nd input
	.in2(4'd0), // 3rd input
	.in3(4'd0), // 4th input
	.ftsd_ctl_en(ftsd_ctl_en) // divided clock for scan control
	);
bcd_d(
   .display(display), // 14-segment display output
	.bcd(bcd) // BCD input
	);	
endmodule
