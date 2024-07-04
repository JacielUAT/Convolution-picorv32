module lim_inf_shape
(  
   input clk,
   input reg [4:0] sizeX,
   input reg [4:0] sizeY,
   output reg [4:0] inf

);

always @ (posedge clk) begin    
		inf <= (sizeY /2);		
end 
endmodule 