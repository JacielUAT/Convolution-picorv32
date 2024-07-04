module fsm (
input clk,
input Start,
input rst_n,
input comp_out,
input shape,
input jfin,
input comp_out_shape,
output reg clr_f,
output reg clr_j,
output reg datogate,
output reg loadj,
output reg loadk,
output reg writez,
output reg loadz,
output reg clrz,

output reg busy,
output reg done
);



enum {E0=0, E1, E2,E3,E4,E5,E6,E7,E8,E9} estados;

reg [7:0] currentState;
reg [7:0] nextState;
       
//Next state logic combinational block      
//Conditions to go nextState       
always @(*) begin  
   
   case (currentState)
      E0: if (Start) begin  // K=0
            nextState=E1;
          end
          else begin 
            nextState=E0;            
          end  
          
      E1: nextState=E2;  // DONE 0 BUSY 1 
      
      E2: nextState=E3;
            
      E3: if(comp_out== 0)  nextState=E0;
            else nextState=E4;
      
      E4: if (shape== 0) nextState=E5;
			else if ( shape == 1 & comp_out_shape ==1) nextState=E8;
            else nextState=E5;
      
      E5: if (jfin == 1) nextState=E7;
			else nextState=E6;
	  
	  E6: nextState=E9;  //E6
	  
	  E7: nextState=E8; 
	  
	  E8: nextState=E2;
	  
	  E9: nextState=E5;
                     
      
      default : nextState=E0;
   endcase 
  
end

// state register logic
//update state
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) currentState= E0;
    
     else currentState<=nextState;
end 




//output logic combinational block
//Logic output from each state.
always @(*) begin
	

   case (currentState)
   
   E0: begin datogate=1'b0; clr_f = 1'b0; clr_j = 1'b0; loadk= 1'b0; clrz= 1'b0; busy= 1'b0 ; done=1'b1; end   
   
   E1: begin datogate=1'b1; clr_f = 1'b1; clr_j = 1'b1; clrz= 1'b1; busy= 1'b1 ; done=1'b0; end  
  
   E2: begin loadk= 1'b0; writez=1'b0;clrz= 1'b0; clr_j = 1'b0; end 
   
   E3: begin clrz= 1'b1;clr_j = 1'b1; end  
   
   E4: ;
   
   E5: begin loadj = 1'b0;  loadz=1'b0; end
   
   E6: begin loadj = 1'b1; end 
   
   E7: begin  writez=1'b1; end 
   
   E8: begin  loadk= 1'b1; end 
   
   E9: begin   loadj = 1'b0; loadz=1'b1; end 
      
   default ;
   
   endcase
 end
 
endmodule