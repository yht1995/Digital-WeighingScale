module HexSSeg
(
	input wire [3:0] hex,
	output reg [6:0] sseg
);


	always @(hex)
		begin
			case(hex)
				4'b0000:sseg=7'b1111110; 
				4'b0001:sseg=7'b0110000; 
				4'b0010:sseg=7'b1101101; 
				4'b0011:sseg=7'b1111001; 
				4'b0100:sseg=7'b0110011; 
				4'b0101:sseg=7'b1011011; 
				4'b0110:sseg=7'b1011111; 
				4'b0111:sseg=7'b1110000; 
				4'b1000:sseg=7'b1111111; 
				4'b1001:sseg=7'b1111011; 
				4'b1010:sseg=7'b1110111;//A 
				4'b1011:sseg=7'b0011101;//o 
				4'b1100:sseg=7'b0110111;//H 
				4'b1101:sseg=7'b0111101;//d 
				4'b1110:sseg=7'b1001111;//E 
				4'b1111:sseg=7'b0000000;//灭零
				default: sseg=7'bx;
			endcase
		end
endmodule