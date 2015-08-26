module FreqDiv
(
	input wire clk_in,
	output reg clk_out
);

parameter N = 50000000/250;

	reg [17:0]r_cnt;
	always @(posedge clk_in)
		begin
			if(r_cnt == N/2-1)
				begin
					r_cnt <= 17'b0;
					clk_out <= ~clk_out;
				end
			else 
				r_cnt <= r_cnt+1'b1;
		end
endmodule