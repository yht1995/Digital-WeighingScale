module FreqDiv
(
	input wire clk_in,
	output reg clk_out
);

	reg [17:0]r_cnt;
	always @(posedge clk_in)
		begin
			if(r_cnt < 17'd99999)
				r_cnt <= r_cnt+1'b1;
			else begin
				r_cnt <= 17'b0;
				clk_out <= ~clk_out;
			end
		end
endmodule