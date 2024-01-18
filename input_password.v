// Module that takes input from keypad.
module input_password(
input clk, rst,
input [3:0] row,
output [3:0] col,
output cycle_complete,
output [15:0] code
);
wire [15:0] number;
//wire [3:0] num;
reg [2:0]count = 0;
wire done;
reg received;

kypd u1 (clk, rst, received, row, col, done, number);

assign cycle_complete = done;
assign code = number;
endmodule
