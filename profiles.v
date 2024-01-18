// Check the input password as well as update the password based on write pin.
module profiles(
input clk, rst, write,
input [15:0] password,
input [3:0] selected_profile,
output valid
);

reg [15:0] profile [3:0];
reg [3:0] t_sel_prof;
reg [15:0] t_pass;
reg t_wr;
reg out;

assign valid = out;

always@ (posedge clk)
begin
	if(!rst)
	begin
		t_sel_prof  <= selected_profile;
		t_wr  <= write;
		t_pass <= password;
	end
end

always@ (t_wr, t_sel_prof, t_pass)
begin
	if(rst)
		out = 1'b0;
	else if (t_wr)
	begin
		profile[t_sel_prof] = t_pass;
		out = 1'b0;
	end
	else
	begin
		if (profile[t_sel_prof] == t_pass)
		begin
			out = 1'b1;
		end
		else
			out = 1'b0;
	end
end
endmodule
