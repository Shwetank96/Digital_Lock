module kypd(
input clk, rst, received,
input [3:0] row, 
output [3:0] col,
output reg new_cycle,
output reg [15:0] number
);
parameter [1:0] col0 = 2'd0, col1 = 2'd1, col2 = 2'd2, col3 = 2'd3;
reg [15:0] button;
reg [1:0] state;
reg [2:0] button_pressed_count;
reg [4:0] count;
reg [11:0] temp_number;
reg [3:0] temp;
wire button_pressed;

assign button_pressed = |button;										// records when a button is pressed. to be used as clock of second ASM in this module.
assign col[0] = (state == col0) ? 1'b0 : 1'b1; 
assign col[1] = (state == col1) ? 1'b0 : 1'b1;
assign col[2] = (state == col2) ? 1'b0 : 1'b1;
assign col[3] = (state == col3) ? 1'b0 : 1'b1;

// First FSM to read the data from the PMOD Keypad.
always@(posedge clk or posedge rst) 
begin
	if(rst) 
	begin
		state <= col0;
	end
	else
	begin
		state <= state + 2'd1;
	end
end

// This always block takes the input from the keypad as a decoder with only 1 pin high when pressed rest 0.
always@(negedge clk) 
begin
	case(state)
		col0: 
		begin
			button[1]  <= ~row[0]; //1
			button[4]  <= ~row[1]; //4
			button[7]  <= ~row[2]; //7
			button[0]  <= ~row[3]; //0
		end
		col1: 
		begin
			button[2]  <= ~row[0]; //2
			button[5]  <= ~row[1]; //5
			button[8]  <= ~row[2]; //8
			button[15] <= ~row[3]; //F
		end
		col2: 
		begin
			button[3]  <= ~row[0]; //3
			button[6]  <= ~row[1]; //6
			button[9]  <= ~row[2]; //9
			button[14] <= ~row[3]; //E
		end
		col3: 
		begin
			button[10] <= ~row[0]; //A
			button[11] <= ~row[1]; //B
			button[12] <= ~row[2]; //C
			button[13] <= ~row[3]; //D
		end
	endcase
end

// This block is a encoder that converts the input to corresponding output values.
always@ (negedge clk) 
begin
	casex(button)
		16'b1xxxxxxxxxxxxxxx: temp = 4'hf;
		16'b01xxxxxxxxxxxxxx: temp = 4'he;
		16'b001xxxxxxxxxxxxx: temp = 4'hd;
		16'b0001xxxxxxxxxxxx: temp = 4'hc;
		16'b00001xxxxxxxxxxx: temp = 4'hb;
		16'b000001xxxxxxxxxx: temp = 4'ha;
		16'b0000001xxxxxxxxx: temp = 4'h9;
		16'b00000001xxxxxxxx: temp = 4'h8;
		16'b000000001xxxxxxx: temp = 4'h7;
		16'b0000000001xxxxxx: temp = 4'h6;
		16'b00000000001xxxxx: temp = 4'h5;
		16'b000000000001xxxx: temp = 4'h4;
		16'b0000000000001xxx: temp = 4'h3;
		16'b00000000000001xx: temp = 4'h2;
		16'b000000000000001x: temp = 4'h1;
		16'b0000000000000001: temp = 4'h0;
	endcase
end

// based on the button pressed, we are creating a 4 input alpha-numeric code which is treated as input for password check or updation.
always@(negedge button_pressed,posedge rst)
begin
	if (rst)
	begin
		button_pressed_count = 0;
		new_cycle = 0;
		number = 0;
		temp_number = 0;
	end
	else if(received)
	begin
		button_pressed_count = 0;
		new_cycle = 0;
		number = 0;
		temp_number = 0;
	end
	else if(button_pressed_count == 3'd3)
	begin
		number = {temp_number,temp};
		button_pressed_count = button_pressed_count + 1;
		new_cycle = 1'b1;
	end
	else if(button_pressed_count == 3'd2)
	begin
		temp_number[3:0] = temp;
		button_pressed_count = button_pressed_count + 1;
		new_cycle = 1'b0;
	end
	else if(button_pressed_count == 3'd1)
	begin
		temp_number[7:4] = temp;
		button_pressed_count = button_pressed_count + 1;
		new_cycle = 1'b0;
	end
	else if(button_pressed_count == 3'd0)
	begin
		temp_number[11:8] = temp;
		button_pressed_count = button_pressed_count + 1;
		new_cycle = 1'b0;
	end
	else if(button_pressed_count == 3'd4)
	begin
		button_pressed_count = 0;
		new_cycle = 0;
		number = 0;
		temp_number = 0;
	end
end
endmodule
