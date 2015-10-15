`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:35:17 09/10/2015 
// Design Name: 
// Module Name:    freq_div_inter_speaker 
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
`define FREQ_DIV_BIT 25
module freq_div_inter_speaker(
  
	clk, // global clock input
	rst_n, // active low reset
	clk_5MHz,
	clk_5_32MHz,
	cnt_m
	);
	output cnt_m;
	output reg clk_5_32MHz;
	output reg clk_5MHz;
	input clk; // global clock input
	input rst_n; // active low reset
	reg [3:0]cnt_m;
	reg [`FREQ_DIV_BIT-9:0]cnt_h;
	reg [2:0] cnt_l; // temp buf of the counter
	reg [`FREQ_DIV_BIT-1:0] cnt_tmp; // input to dff (in always block)
	// Combinational logics: increment, neglecting overflow 
	always @( cnt_h or clk_5_32MHz or cnt_m or clk_5MHz or cnt_l)
		cnt_tmp <= {cnt_h,clk_5_32MHz,cnt_m,clk_5MHz,cnt_l} + 1'b1;
	// Sequential logics: Flip flops
	always @(posedge clk or negedge rst_n)
		if (~rst_n) {cnt_h,clk_5_32MHz,cnt_m,clk_5MHz,cnt_l}<=`FREQ_DIV_BIT'd0;
		else {cnt_h,clk_5_32MHz,cnt_m,clk_5MHz,cnt_l}<=cnt_tmp;


endmodule
