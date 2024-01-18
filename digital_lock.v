// Top module of the Project.
module digital_lock(
input clk, rst, add_profile, d3_in,
input [3:0] profile_selected,
input [3:0] row,
output [3:0] col,
output [1:0] high, low,
output valid, 
output reg locked,
output [6:0] dis_code0, dis_code1, dis_code2, dis_code3
);
// d3_in gives the input 1 if the lock has been moved from its original position by approximately 5m. 
// currently it is mapped to a push button on fpga instead of GSM as the GSM was giving very unreliable data.
// locked pin is an LED warning that the d3_in pin has changed its value.
// pins row, col, high and low are the GPIO inputs and outputs to the pmod keypad interface.
// LED mapped valid gives the output of the lock. 1 if password matched, 0 if invalid.

// definig the required registered.
wire [15:0] code;
reg [15:0] pass_code;
wire input_done;
wire [3:0] t_prof_sel, t_add_prof;
wire divclk;
reg [24:0] divcntr;
reg [15:0] d3_fix;

assign t_add_prof = add_profile;
assign t_prof_sel = profile_selected;
assign divclk = divcntr[15];						// clock divider to get the required frequency.
assign high = 2'b11;
assign low = 2'b00;

// Module call to take input password and validate it.
input_password in_pass (divclk, rst, row, col, input_done, code);
profiles prof (divclk, (rst | ~input_done), t_add_prof, code, t_prof_sel, valid);

disp_7segment disp1 (pass_code[3:0]  , dis_code0);
disp_7segment disp2 (pass_code[7:4]  , dis_code1);
disp_7segment disp3 (pass_code[11:8] , dis_code2);
disp_7segment disp4 (pass_code[15:12], dis_code3);

always@ (posedge divclk)
begin
	if (rst)
	begin
		pass_code = 16'd0;
	end
	else if (input_done)
		pass_code = code;
	else
		pass_code = 16'd0;
end

// clock divider.
always@(posedge clk)
	divcntr <= divcntr + 25'd1;

// Code for Locked pin.	
always@ (posedge divclk)
begin
	if(rst)
	begin
		d3_fix = 15'hffff;
		locked = 1'b0;
	end
	else if (!locked)
		locked = ~(&d3_fix);
	else
	begin
		locked = 1'b1;
	end
	d3_fix = (d3_fix<<1) + d3_in;
	
end
endmodule
