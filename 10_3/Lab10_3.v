`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:15:45 09/14/2015 
// Design Name: 
// Module Name:    Lab10_3 
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
module Lab10_3(
switch_tone,
col_n,
clk, // clock from crystal
reset, // active low reset
audio_appsel, // playing mode selection
audio_sysclk, // control clock for DAC (from crystal)
audio_bck, // bit clock of audio data (5MHz)
audio_ws, // left/right parallel to serial control
audio_data, // serial output audio data
display,
display_ctl,
row_n
);
input switch_tone;
input [3:0]col_n;
// I/O declaration
input clk; // clock from the crystal
input reset; // active low reset
output audio_appsel; // playing mode selection
output audio_sysclk; // control clock for DAC (from crystal)
output audio_bck; // bit clock of audio data (5MHz)
output audio_ws; // left/right parallel to serial control
output audio_data; // serial output audio data
output [14:0]display;
output [3:0]display_ctl;
output [3:0]row_n;
//output [15:0]LED;
// Declare internal nodes
wire [15:0] audio_in_left, audio_in_right;



wire [1:0]ftsd_ctl_en;
wire [3:0]bcd;
wire clk_out;
wire clk_150;
wire pressed;
// Note generation
reg [3:0]sound_level1,sound_level0;
reg [19:0]input_sound,input_sound2;
wire [3:0]sound_sel;
always@(posedge clk or negedge reset)
begin
	if(~reset)
	begin
		input_sound<=20'd0;
	end
	else
	begin
		if(switch_tone==0)
		begin
			case(sound_sel)
			4'd10:input_sound<=20'd181818;//low la
			4'd0:input_sound<=20'd163265;//low si
			4'd1:input_sound<=20'd153257;//mid do
			4'd2:input_sound<=20'd136519;//mid re
			4'd3:input_sound<=20'd121212;//mid mi
			4'd4:input_sound<=20'd114613;//mid fa
			4'd5:input_sound<=20'd102041;//mid so
			4'd6:input_sound<=20'd90909;//mid la
			4'd7:input_sound<=20'd80972;//mid si
			4'd8:input_sound<=20'd76336;//h do
			4'd9:input_sound<=20'd68027;//h re 
			4'd11:input_sound<=20'd60606;//h mi 
			4'd12:input_sound<=20'd57307;//h fa
			4'd13:input_sound<=20'd51020;//h so
			4'd14:input_sound<=20'd45455;//h la
			4'd15:input_sound<=20'd40486;//h si
			endcase
			input_sound2<=input_sound;
		end
		else
		begin
			case(sound_sel)
			4'd1:
			begin
			input_sound<=20'd153257;//mid do
			input_sound2<=20'd121212;
			end
			4'd2:
			begin
			input_sound<=20'd136519;//mid re
			input_sound2<=20'd114613;
			end
			4'd3:
			begin
			input_sound<=20'd121212;//mid mi
			input_sound2<=20'd102041;
			end
			4'd4:
			begin
			input_sound<=20'd114613;//mid fa
			input_sound2<=20'd90909;
			end
			4'd5:
			begin
			input_sound<=20'd102041;//mid so
			input_sound2<=20'd80972;
			end
			
			4'd8:
			begin
			input_sound<=20'd76336;//h do
			input_sound2<=20'd60606;
			end
			4'd9:
			begin
			input_sound<=20'd68027;//h re
			input_sound2<=20'd57307;
			end
			4'd11:
			begin
			input_sound<=20'd60606;//h mi
			input_sound2<=20'd51020;
			end
			4'd12:
			begin
			input_sound<=20'd57307;//h fa
			input_sound2<=20'd45455;
			end
			4'd13:
			begin
			input_sound<=20'd51020;//h so
			input_sound2<=20'd40486;
			end
			default:
			begin
			input_sound<=20'd153257;//mid do
			input_sound2<=input_sound;
			end
			endcase
		end
	end
end

always@(posedge clk or negedge reset)
begin
	if(~reset)
	begin
		sound_level1<=4'd9;
		sound_level0<=4'd5;
	end
	else
	begin
		case(sound_sel)
		4'd10:
			begin
			sound_level1<=4'd8;
			sound_level0<=4'd7;//low la
			end
		4'd0:
			begin
			sound_level1<=4'd9;
			sound_level0<=4'd5;//low si
			end
		4'd1:
			begin
			sound_level1<=4'd0;
			sound_level0<=4'd1;//mid do
			end
		4'd2:
		begin
		sound_level1<=4'd2;
		sound_level0<=4'd3;//mid re
		end
		4'd3:
		begin
		sound_level1<=4'd4;
		sound_level0<=4'd5;//mid mi
		end
		4'd4:
		begin
		sound_level1<=4'd6;
		sound_level0<=4'd7;//mid fa
		end
		4'd5:
		begin
		sound_level1<=4'd9;
		sound_level0<=4'd1;//mid so
		end
		4'd6:
		begin
		sound_level1<=4'd8;
		sound_level0<=4'd7;//mid la
		end
		4'd7:
		begin
		sound_level1<=4'd9;
		sound_level0<=4'd5;//mid si
		end
		4'd8:
		begin
		sound_level1<=4'd0;
		sound_level0<=4'd1;//h do
		end
		4'd9:
		begin
		sound_level1<=4'd2;
		sound_level0<=4'd3;//h re 
		end
		4'd11:
		begin
		sound_level1<=4'd4;
		sound_level0<=4'd5;//h mi 
		end
		4'd12:
		begin
		sound_level1<=4'd6;
		sound_level0<=4'd7;//h fa
		end
		4'd13:
		begin
		sound_level1<=4'd9;
		sound_level0<=4'd1;//h so
		end
		4'd14:
		begin
		sound_level1<=4'd8;
		sound_level0<=4'd7;//h la
		end
		4'd15:
		begin
		sound_level1<=4'd9;
		sound_level0<=4'd5;//h si
		end
		endcase
	end
end
buzzer_control Ung(
.low_clk(clk_out),
.clk(clk), // clock from crystal
.rst_n(reset), // active low reset
.note_div(input_sound), // div for note generation
.note_div2(input_sound2),
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
	.clk_150(clk_150),
	.clk_ctl(ftsd_ctl_en), // divided clock output for scan freq
	.clk(clk), // global clock input
	.rst_n(reset) // active low reset
	);
scanf sf(
   .ftsd_ctl(display_ctl), // ftsd display control signal 
	.ftsd_in(bcd), // output to ftsd display
	.in0(4'd0), // 1st input
	.in1(4'd0), // 2nd input
	.in2(sound_level1), // 3rd input
	.in3(sound_level0), // 4th input
	.ftsd_ctl_en(ftsd_ctl_en) // divided clock for scan control
	);
bcd_d(
   .display(display), // 14-segment display output
	.bcd(bcd) // BCD input
	);
keypad_scan(
.clk(clk_150), // scan clock
.rst_n(reset), // active low reset
.col_n(col_n), // pressed column index
.row_n(row_n), // scanned row index
.key(sound_sel), // returned pressed key
.pressed(pressed) // whether key pressed (1) or not (0)
);	
endmodule
