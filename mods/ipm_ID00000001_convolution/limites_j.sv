module limites_j
(     
   input reg [4:0] sizeY,
   input reg [4:0] sizeX,
   input reg [5:0] K,   
   output reg [7:0] inicio,
   output reg [7:0] fin
   
);
reg signed [7:0] r1;
reg  signed [7:0] r2;

always @(*) begin 
   r1=K - sizeY  +1'b1;
   r2=sizeX-1'b1;
end  

always@(*) begin
   
   inicio = (0 > r1) ? 0 : r1;
   fin    = (K < r2 ) ?  K : r2;
end 
endmodule 