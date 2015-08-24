// Quartus II Verilog Template
// 4-State Moore state machine

// A Moore machine's outputs are dependent only on the current state.
// The output is written only when the state changes.  (State
// transitions are synchronous.)

module DispScan
(
	input clk,en,
	input [3:0]in0,in1,in2,in3,
	output reg [3:0]select,out
);

	// Declare state register
	reg		[1:0]state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	// Output depends only on the state
	always @ (state or en) 
	begin
		if (en)
			begin
			case (state)
				S0:
					begin
						select <= 4'b0001;
						out[3:0] <= in0[3:0];
					end
				S1:
					begin
						select <= 4'b0010;
						out[3:0] <= in1[3:0];
					end	
				S2:
					begin
						select <= 4'b0100;
						out[3:0] <= in2[3:0];
					end
				S3:
					begin
						select <= 4'b1000;
						out[3:0] <= in3[3:0];
					end
				default:
					out = 4'b0000;
			endcase
			end
		else
			select <= 4'b0000;
	end

	// Determine the next state
	always @ (posedge clk) begin
		case (state)
			S0:
				state <= S1;
			S1:
				state <= S2;
			S2:
				state <= S3;
			S3:
				state <= S0;
		endcase
	end
endmodule
