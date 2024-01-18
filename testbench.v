`timescale 1ns/1ps
module testbench();
reg clk, rst;
reg [3:0] row;
wire [3:0] col;
wire [15:0] code;

input_password ut (clk, rst, row, col, code);

initial
begin
	clk = 1'b1;
	rst = 1'b1;
	row = 4'he;
	#10 row = 4'hf;
	#35 rst = ~rst;
	#10 row = 4'he;
	#10 row = 4'hf;
	#40 row = 4'h7;
	#10 row = 4'hf;
	#50 row = 4'hb;
	#10 row = 4'hf;
	#60 row = 4'hd;
	#10 row = 4'hf;
	#20 $stop;
end

always #5 clk = ~clk;
endmodule

//`timescale 1ns/1ps
//module testbench();
//reg clk, rst;
//reg [3:0] row;
//wire [3:0] col;
//wire button_pressed;
//wire [3:0] num_val;
//
//kypd ut (clk, rst, row, col, button_pressed, num_val);
//
//initial
//begin
//	clk = 1'b1;
//	rst = 1'b1;
//	row = 4'hf;
//	#5 rst = ~rst;
//	#10 row = 4'he;
//	#10 row = 4'hf;
//	#40 row = 4'h7;
//	#10 row = 4'hf;
//	#50 row = 4'hb;
//	#10 row = 4'hf;
//	#60 row = 4'hd;
//	#10 row = 4'hf;
//	#20 $stop;
//end
//
//always #5 clk = ~clk;
//endmodule
