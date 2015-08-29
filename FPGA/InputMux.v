module InputMux
(
	input clk,
	input [3:0]IR_Code,Key_Code,
	input IR_Press,Key_Press,
	output reg [3:0]Code,
	output reg Press
);


assign tPress = IR_Press | Key_Press;

always @(posedge tPress)
begin
	if(Key_Press)
		Code <= Key_Code;
	else
		Code <= IR_Code;
end

always @(posedge clk)
begin
	Press <= tPress;
end

endmodule


