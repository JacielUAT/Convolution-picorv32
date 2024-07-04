module addressXYZ

(
   input clk,
   input reg [5:0] j,
   input reg [5:0] K,
   
   output reg [4:0] addrX,
   output reg [4:0] addrY,
   output reg [5:0] addrZ
   
);

always @(posedge clk) begin 

   addrX<= j;
   addrY<= K-j;
   addrZ<= K;

end 

endmodule 