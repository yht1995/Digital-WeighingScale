module BinToDec
(
	input wire [7:0] bin,
	output reg [3:0] bit1,bit2,bit3
);

reg [7:0] temp;

always @(bin)
	begin
		temp <= bin;
		bit3 <= temp/100;
		bit2 <= temp/10;
		bit1 <= temp%100;
		
		
//		while(temp)
//		begin
//		   bit1 <= bit1+1;
//			if(bit1 == 4'b1010)
//			begin
//				bit2 <= bit2+1;
//				if(bit2 == 4'b1010)
//				begin
//					bit3 <= bit3+1;
//				end
//			end
//			temp <= temp-1;
//		end
	end
endmodule