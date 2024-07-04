module lim_sup_shape
(   
   input clk,
   input reg [4:0] sizeX,
   input reg [4:0] sizeY,
   output reg [4:0] sup

);

always@(posedge clk) begin	  
		sup <= (sizeY /2) + sizeX;	
end 

endmodule 