/******************************************************************
* Description
*
* Simple dual port ram with single clock 
*
* Parameters: DATAWIDTH  -> Width of data stored/read 
*             ADDR_WIDTH -> Width of the bus address  
*
* Author:
* email :	vidkar.delgado@cinvestav.mx
* Date  :	05/07/2020
******************************************************************/


module memZ #(
		parameter DATA_WIDTH= 16,
		parameter ADDR_WIDTH= 6,
		parameter TXT_FILE= "C:/Users/mijju/Documents/Doctorado/cuatri 4/SEMI/SoC/ModelSimProyecto/work/memZ.txt"
)(
		input  logic                  clk,		
		input  logic                  write_en_i,
		input  logic [ADDR_WIDTH-1:0] write_addr_i,				
		input  logic [ADDR_WIDTH-1:0] read_addr_i,
		input  logic [DATA_WIDTH-1:0] write_data_i,
		output logic [DATA_WIDTH-1:0] read_data_o
	   
);

// signal declaration
logic [DATA_WIDTH-1:0] RAM_structure [2**ADDR_WIDTH-1:0]; 

//initial begin  //load hexadecimal data in txt
				
//end

//write and read operations
always_ff @ (posedge clk) begin
		if(write_en_i)
				RAM_structure[write_addr_i] <= write_data_i;
		$writememh(TXT_FILE, RAM_structure);
		read_data_o <= RAM_structure[read_addr_i];		
end

endmodule
