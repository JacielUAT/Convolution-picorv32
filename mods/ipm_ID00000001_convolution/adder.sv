module adder 

(  input clk, 
	input reg [4:0] a,
   input reg [4:0] b,
   output reg [5:0] r

	
);
      always @(posedge clk) begin
         r <= a + b - 1'b1;         
      end
      
endmodule 