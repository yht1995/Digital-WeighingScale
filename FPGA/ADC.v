module ADC
(
	input  wire clk_in,
	input  wire [7:0]data_in,
	output wire read,
	output reg  [7:0]data_ch1,data_ch2,data_ch3,
	output [1:0]in
);

reg [3:0]state;

always @ (posedge clk_in)
begin
	state <= state + 1'b1;
end

assign read = (state[1]^state[0]) ? 1'b0 : 1'b1;
assign in[1] = state[3];
assign in[0] = state[2];

always @(state)
begin
	case(state)
		4'b0110:data_ch1 <= data_in<<2;
		4'b1010:data_ch2 <= data_in;
		4'b1110:data_ch3 <= data_in;
	endcase
end

endmodule