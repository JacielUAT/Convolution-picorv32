module oper_convolution 
(
   input clk,
   input reg [7:0] dataX,
   input reg [7:0] dataY,
   input clr_z,
   input load_z,  // 
   input reg [15:0] dataZ_in,
   output reg [15:0] dataZ_out

);
reg [15:0] multiplica;
assign multiplica = dataX * dataY;

always@ (posedge clk) begin

   if (!clr_z) begin
      dataZ_out <= 16'b0000000000000000;
   end 
   else if (load_z) begin 
      dataZ_out <= dataZ_in + (multiplica);
   end
   
  else 
      dataZ_out <= dataZ_in;   
end 

endmodule 