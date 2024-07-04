/*	
   ===================================================================
   Module Name : FF SR
         
   Filename    : ff_sr.v
   Type        : Verilog Module
      
   Description : A flip fliop sr with clock
   ------------------------------------------------------------------
      clocks   : posedge clock "clk"
      reset    : async negedge "rstn"
      set      : sync posedge "clrh"
      Q        : output "q" 
	  ~Q       : output_n "q_n"
      
   Parameters  :
         NAME            Comments                Default
         ---------------------------------------------------
         DATA_WIDTH      Register's data width     8
      
   ------------------------------------------------------------------
   Version     : 1.0
   Data        : 30 Apr 2024
   Revision    : -
   Reviser     : -		
   -------------------------------------------------------------------
   Modification Log "please register all the modifications in this area"
   (D/M/Y)  
   
   ----------------------
   // Instance template
   ----------------------
flip_flop_sr 
" FLIP FLOP SR"
(
	.clk (),
	.set (),
	.reset (),
	.q (),
	.q_n ()
);
*/

module flip_flop_sr 
(
	input clk,
	input set,
	input reset,
	output reg q,
	output reg q_n
);

 always@(posedge clk) begin  
       
        if(set==0 && reset==0) begin
           q<=q; 
           q_n<=q_n; 
        end
        else if(set==0 && reset==1) begin
           q<=1'b0; 
           q_n<=1'b1; 
        end
        else if(set==1 && reset==0) begin
           q<=1'b1; q_n<=1'b0; 
        end
        else  begin //(set==1 && reset==1)
           q<=1'bx; q_n<=1'bx; 
  end   
  
     
    end
endmodule











