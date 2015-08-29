module Process
(
   input [3:0] bit1, bit2, bit3, 
   input Clock, press, reset,
	input [3:0] key, 
	output reg [3:0] out0, out1, out2, out3,
	output reg judge
);

reg[7:0] age, height, weight;
reg[3:0] temp0, temp1, temp2, temp3, dig0, dig1, dig2, dig3;
reg[1:0] state, setting, sex;

reg[10:0] count, flash;

parameter
   Welcome = 2'b00,
   Set = 2'b01,
	Measure = 2'b10,
	Read = 2'b11;

parameter
	Ready = 2'b00,
   Sex = 2'b01,
	Age = 2'b10,
	Height = 2'b11;
	
always @(posedge press)
begin
   judge <= 1;
   if(key == 4'hc)
	begin
	   setting <= Sex;
		{dig3, dig2, dig1, dig0} <= 16'b0101111111111111;
		age <= 0;
		sex <= 0;
		height <= 0;
		
	end
	else if(state == Set)
	begin
		if(setting == Sex)
		begin
			if(key == 1 || key == 2)
			begin
			   sex <= key;
				dig0 <= key;
			end
			else if(key == 4'ha)
			begin
				sex <= 0;
				dig0 <= 4'b1111;
			end
			else if(key == 4'hb && sex)
			begin
			   {dig3, dig2, dig1, dig0} <= 16'b1010111111111111;
			   setting <= Age;
			end
		end
		else if(setting == Age)
		begin
			if(key < 10 && age < 15)
			begin
			   age <= age*10+key;
				dig0 <= key;
				dig2 <= dig1;	
			   if(age)
					dig1 <= dig0;
			end
			else if(key == 4'ha)
			begin
			   age <= 0;
				{dig3, dig2, dig1, dig0} <= 16'b1010111111111111;
			end
			else if(key == 4'hb && age)
			begin
			   setting <= Height;
		      {dig3, dig2, dig1, dig0} <= 16'b1100111111111111;
			end
		end
		else if(setting == Height)
	   begin		
    		if(key < 10 && height < 25)
			begin
			   height <= height*10+key;
				dig0 <= key;
			   dig2 <= dig1;	
			   if(height)
					dig1 <= dig0;
			end
			else if(key == 4'ha)
			begin
			   height <= 0;
				{dig3, dig2, dig1, dig0} <= 16'b1100111111111111;
			end
    		else if(key == 4'hb && height) 
			begin
			   setting <= Ready;
				{dig3, dig2, dig1, dig0} <= 16'b1001101110111101;
			end
      end
	end
end		
		
always @(posedge Clock)
begin
 //  if(state == Welcome)
	//   judge <= 1;
   if(setting == Sex)
	begin
	   state <= Set;
		count <= 0;
	//	   judge<=0;
	end
	else
	begin
	   case(state)
		Measure:
		begin
	      if(temp2 == bit2 && temp3 == bit3)
	         count <= count+1;
	      else
		      count <= 0;
		   temp1 <= bit1;
		   temp2 <= bit2;
		   temp3 <= bit3;
         if(count == 1000)
		   begin
		      state <=	Read;
	//         judge <= 0;				
		      count <= 0;
		   end
	   end
		Read:
		begin
	      if(count)
			begin
	         count <= count+1;
	         if(count == 1000)
	         begin
		         state <= Measure;
	//				judge <= 1;
		         count <= 0;
		      end
	      end
			else if(temp3 != bit3)
	         count <= count+1;
	   end
		Set:
		   if(setting == Ready)
			begin
			   count <= count+1;
	         if(count == 500)
		      begin
		         state <= Measure;
			      count <= 0;
		      end
			end
			else
			   count <= 0;
		default:
		begin
		/*   if(count)
			begin
	         count <= count+1;
	         if(count == 500)
	         begin
		         {temp3, temp2, temp1, temp0} <= 16'b1100111011001110;
					judge<=1;
		         count <= 0;
		      end
	      end
			else
	         count <= count+1;
		end*/
		judge<=1;
	end
		endcase
	end
end
		
always @(state or judge)
begin
   case(state)
	Set:
      {out3, out2, out1, out0} <= {dig3, dig2, dig1, dig0};
	Measure:
		{out3, out2, out1, out0} <= {4'b1111, bit3, bit2, bit1};
	Read:
		{out3, out2, out1, out0} <= {4'b1111, temp3, temp2, temp1};
	default:
	   {out3, out2, out1, out0} <= {temp3, temp2, temp1, temp0};
	endcase	 
end
		
endmodule
