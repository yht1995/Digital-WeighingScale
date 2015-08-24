module ADC
(
	input wire clk_in,
	input wire [7:0]data_in,
	output wire read,
	output reg [7:0]data_out 
);

reg [1:0]state;

always @ (posedge clk_in)
begin
	state <= state + 1'b1;
end

assign read = &state ? 1'b0 : 1'b1;

always @ (state)
begin
	if(state == 2'b10)
	begin
		data_out <= data_in;
	end
end

endmodule