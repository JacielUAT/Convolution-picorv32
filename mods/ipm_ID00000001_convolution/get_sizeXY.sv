module get_sizeXY
(
	input clk,	
   input bitgate,
   input reg [4:0] sizeX,
   input reg [4:0] sizeY,
	output reg [4:0] sizeX_,
   output reg [4:0] sizeY_
   
);


always@(posedge clk) begin 
   if (bitgate) begin
      sizeX_ = sizeX;
      sizeY_ = sizeY;  
   end
   else begin
      sizeX_=sizeX;
      sizeY_=sizeY;          
   end     
end
endmodule 