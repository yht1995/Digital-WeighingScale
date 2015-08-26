module IRDecode(
	input wire [7:0] code,
	output reg [3:0] key
);

always @ (code)
begin
	case(code)
	8'h16:key = 0;
	8'h0C:key = 1;
	8'h18:key = 2;
	8'h5E:key = 3;
	8'h08:key = 4;
	8'h1C:key = 5;
	8'h5A:key = 6;
	8'h42:key = 7;
	8'h52:key = 8;
	8'h4A:key = 9;
	default:key = 0;
	endcase
end

endmodule