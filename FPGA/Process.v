module Process
(  
   input Clock, press, reset, 
   input [7:0] voltage, current,
   input [3:0] key, bit1, bit2, bit3, 
	output reg [3:0] out0, out1, out2, out3,
	output reg dip
);

reg[7:0] age, vol, cur;
reg[3:0] temp0, temp1, temp2, temp3, dig0, dig1, dig2, dig3;
reg[1:0] state, setting;

reg[25:0] height, weight, BMI, TBW, sex;
reg[10:0] count, flash;

wire[3:0] BMI1, BMI2, BMI3, TBW1, TBW2, TBW3;

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
	
always @(posedge press /*or negedge reset*/)
begin 
 /**  if(!reset)
	begin
	   setting <= Sex;
		age <= 0;
		sex <= 0;
		height <= 0;
	end
   else */if(key == 4'hc)
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
				dig2 = dig1;	
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
			   height <= height * height;
			   setting <= Ready;
				{dig3, dig2, dig1, dig0} <= 16'b1001101110111101;
			end
      end
	end
end		
		
always @(posedge Clock /*or negedge reset*/)
begin
  /* if(!reset)
	begin
	   state <= Welcome;
		count <= 0;
	end
   else*/ if(setting == Sex)
	begin
	   state <= Set;
		count <= 0;
		flash <= 0;
	end
	else
	begin
	   case(state)
		Set:
		   if(setting == Ready)
			begin
			   count <= count+1;
	         if(count == 250)
		      begin
		         state <= Measure;
			      count <= 0;
		      end
			end
			else
			   count <= 0;
		Measure:
		begin
		   if(count == 500)
		   begin
			   flash <= flash+1;
				BMI <= weight * 100000 / height;
				TBW <= 1000 - ((height * current / voltage) /512 + sex * 4 + weight /4) * 100 /73;
				if(flash == 500)
				begin
		         state <=	Read;
	            flash <= 750;  				
		         count <= 0;
				end
		   end
		   else
			begin
	         if(temp2 == bit2 && temp3 == bit3)
	            count <= count+1;
	         else
		         count <= 0;
		      temp1 <= bit1;
		      temp2 <= bit2;
		      temp3 <= bit3;
				weight <= temp3*100+temp2*10+temp1;
			end
	   end
		Read:
		begin
			if(!flash)
			   flash <= 750;
			else	
		      flash <= flash-1;
	      if(count)
			begin
	         count <= count+1;
	         if(count == 2000)
	         begin
		         state <= Measure;
					flash <= 0;
		         count <= 0;
		      end
	      end
			else if(!(bit3 && bit2 && bit1))
	         count <= count+1;
	   end
		default:
		begin
	/*	   if(count)
			begin
	         count <= count+1;
	         if(count == 500)
	         begin
		         {temp3, temp2, temp1, temp0} <= 16'b1100111011001110;
		         count <= 0;
					state <= Set;
		      end
	      end
			else
	         count <= count+1;*/
		end
		endcase
	end
end

BinToDec b1(.Code(BMI[7:0]),.bit1(BMI1),.bit2(BMI2),.bit3(BMI3));
BinToDec b2(.Code(TBW[7:0]),.bit1(TBW1),.bit2(TBW2),.bit3(TBW3));

always @(state or bit1 or bit2 or bit3 or flash)
begin
   case(state)
	/*Welcome:
	   {out3, out2, out1, out0} = 16'b1100111011001110;*/
	Set:
	   begin
         {out3, out2, out1, out0} <= {dig3, dig2, dig1, dig0};
			dip <= 0;
		end
	Measure:
	   begin
		   dip <= 0;
	      if((flash>0 && flash<125) || (flash>250 && flash<375))
            {out3, out2, out1, out0} <= 16'b1111111111111111;
	      else
		      {out3, out2, out1, out0} <= {4'b1111, temp3, temp2, temp1};
		end
	Read:
	   if(flash>500)
		begin
		   {out3, out2, out1, out0} <= {4'b1111, temp3, temp2, temp1};
			dip <= 0;
		end
	   else if(flash>250)
		begin
		   {out3, out2, out1, out0} <= {4'b1111, BMI3, BMI2, BMI1};
			dip <= 1;
		end
		else		
		begin
         {out3, out2, out1, out0} <= {4'b1111, TBW3, TBW2, TBW1};
			dip <= 1;
		end
	endcase	 
end
		
endmodule
