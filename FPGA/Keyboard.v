module Keyboard
(
	input Clock,
	input [3:0]C,						//C为四行线
	output reg press,
	output reg[3:0]CodeOut,	R  	//R为四列线
);	

reg [2:0]state, flag;
parameter						//状态机有六个状态
	KeyNo  = 3'b000,
	State1 = 3'b001,
	State2 = 3'b010,
	State3 = 3'b011,
	State4 = 3'b100,
	KeyYes = 3'b101;
	
	
always @(posedge Clock)
	case(state)
		KeyNo:
			if(C == 4'b1111)
				begin state <= KeyNo; R <= 4'b0000; end
			else
				begin state <= State1; R <= 4'b0111; end
		State1:
			if(C == 4'b1111)
				begin state <= State2; R <= 4'b1011; end
			else
				state <= KeyYes;
		State2:
			if(C == 4'b1111)
				begin	state <= State3; R <= 4'b1101; end
			else
				state <= KeyYes;
		State3:
			if(C == 4'b1111)
				begin state <= State4; R <= 4'b1110; end
			else
				state <= KeyYes;
		State4:
			if(C == 4'b1111)
				begin state <= KeyNo; R <= 4'b0000;	end
			else
				state <= KeyYes;
		KeyYes:
			if(C == 4'b1111)
				begin 
					state <= KeyNo; 
					R <= 4'b0000; 		
					press <= 0;			//按键信号消失或无效，press置0
					flag <= 0;			//计数变量置
				end
			else if(flag < 7)			//人为跳过7个时钟周期
					flag <= flag+1;
			else
				press <= 1;				//按键信号仍存在，press置1
	endcase

always @({C,R})
	case({C,R})
		8'b01110111: CodeOut <= 4'h1;
		8'b01111011: CodeOut <= 4'h4;
		8'b01111101: CodeOut <= 4'h7;
		8'b01111110: CodeOut <= 4'ha;			
				
		8'b10110111: CodeOut <= 4'h2;
		8'b10111011: CodeOut <= 4'h5;
		8'b10111101: CodeOut <= 4'h8;
		8'b10111110: CodeOut <= 4'h0;
					
		8'b11010111: CodeOut <= 4'h3;
		8'b11011011: CodeOut <= 4'h6;
		8'b11011101: CodeOut <= 4'h9;
		8'b11011110: CodeOut <= 4'hb;
		
		8'b11100111: CodeOut <= 4'hc;
		8'b11101011: CodeOut <= 4'hd;
		8'b11101101: CodeOut <= 4'he;
		default: CodeOut <= 4'hf;			
	endcase
endmodule