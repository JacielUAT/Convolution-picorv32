module writez_out

(
   input reg [15:0] dataZin,
   input en_write,
   output reg writeZ,
   output reg [31:0] dataZout
 );
 
 always @(*) begin
 
   if (en_write) begin writeZ=1'b1; dataZout= { { 16{1'b0}},{dataZin} }; end
   else writeZ=1'b0;
 end 
  
 endmodule 