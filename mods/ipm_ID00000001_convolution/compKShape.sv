module compKShape
(
		
   input reg [5:0] K,
   input reg [4:0] inf, 
   input reg [4:0] sup,

    output reg comp_out_shape
   
	
);

always@ (*) begin

   if (K <= (inf-1'b1) | K >= sup) begin // Modelsim if ( $signed(K) <= $signed( inf-1'b1) | K >= sup) begin
      comp_out_shape= 1'b1;
      
   end 
   else 
      comp_out_shape= 1'b0; 
      
end 

endmodule 