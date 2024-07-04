module KsumFor 
(
	input clk,	
   input clr_f,
   input load,
   input reg [5:0] K,     
	output reg [5:0] K_out
   
	
);

always@ (posedge clk, negedge clr_f) begin
   if (!clr_f) begin
      K_out <= 6'b000000;
   end 
   else if (load) begin 
      K_out <= K + 1'b1;
   end   
  else 
      K_out <= K_out;   
end 
endmodule 