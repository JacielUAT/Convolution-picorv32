module comparaj_fin

(  
   input reg [5:0] j,
   input reg [7:0] fin,
   output reg jfin

);
reg [5:0] fin_mas_uno;

assign fin_mas_uno = fin+1'b1; //

always@(*) begin
	if (j < (fin_mas_uno))  jfin = 1'b0;
     else jfin = 1'b1;;

end

endmodule 