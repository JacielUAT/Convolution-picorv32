module jFor 
(
	input clk,	
   input clr_j,
   input load_j,
   input reg [7:0]inicio,
   input reg [5:0] j,     
	output reg [5:0] j_out
   
	
);

always@ (posedge clk, negedge clr_j) begin
   if (!clr_j) begin
      j_out <= inicio;
   end 
   else if (load_j) begin 
      j_out <= j + 1'b1;
   end
   
  else 
      j_out <= j;   
end 

endmodule 