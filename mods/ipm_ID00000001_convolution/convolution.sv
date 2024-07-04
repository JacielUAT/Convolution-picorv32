module convolution     
(

output reg [4:0] memX_addr,
input reg  [7:0] dataX,
//input reg [4:0] sizeX,//


output reg [4:0] memY_addr,
input reg  [7:0] dataY,
//input reg [4:0] sizeY,//

input start,
//input shape,

output reg  [31:0] dataZ,
output reg [5:0] memZ_addr,
output writeZ,
//output busy,
//output done,

input reg [31:0] data_ConfigReg,

output reg [7:0] status_IPcore,
output reg [7:0] int_IPcore,

input reg en_s,


//         31 | 30 | 29 | 28 | 27 | 26 | 25 | 24 | 23 | 22 | 21 | 20 | | 19 | 18 | 17 | 16 | 15 | 14 | 13 | 12 | 11 | 10 |  9 |  8 |  7 |  6 |  5 |  4 |  3 |  2 |  1 |  0 |
//                                                                                                                    Sy   Sy   Sy   Sy   Sy   Sx  Sx   Sx   Sx   Sx   shape

//output reg [7:0] estados_o,


input clk,
input rst_n

);


`define  shape  data_ConfigReg [1]
`define  sizeX  data_ConfigReg [6:2]
`define  sizeY  data_ConfigReg [11:7]

parameter ADDR_WIDTH_MEMI = 'd6;
parameter ADDR_WIDTH_MEMO = 'd6;
parameter SIZE_CR = 'd1;

wire datogate_wire;
wire [4:0] sizeX_wire;
wire [4:0] sizeY_wire;

wire [5:0] temp_sum_wire;
wire [5:0] K_wire;

wire comp_out_wire;

wire clr_f_wire;
wire load_wire;

wire [7:0] inicio_wire;
wire [7:0] fin_wire;

wire [5:0] j_wire;
wire clr_j_wire;
wire load_j_wire;

wire jfin_wire;

wire [15:0]data_z_wire;
wire clr_z_wire;
wire load_z_wire;

wire en_write_wire;
wire [15:0] dataz_wire;

wire [4:0] inf_wire;
wire [4:0] sup_wire;
wire comp_out_shape_wire;





fsm DUT1 ( .Start(start), .datogate(datogate_wire), .clk(clk) ,.rst_n(rst_n),.comp_out(comp_out_wire), .clr_f(clr_f_wire), .clr_j(clr_j_wire),
            .shape(`shape),.writez(en_write_wire), .loadj(load_j_wire), .loadk(load_wire ), .jfin(jfin_wire), .loadz(load_z_wire), .clrz(clr_z_wire),
			 .busy(status_IPcore[0]), .done(int_IPcore[0]), .comp_out_shape(comp_out_shape_wire) );  			
			
get_sizeXY DUT2( .clk(clk), .bitgate(datogate_wire), .sizeX(`sizeX), .sizeY(`sizeY), .sizeX_(sizeX_wire), .sizeY_(sizeY_wire) );

adder DUT3 (.clk(clk), .a(sizeX_wire), .b(sizeY_wire), .r(temp_sum_wire) );
compK DUT4 (.temp_adder(temp_sum_wire), .comp_out(comp_out_wire), .K(K_wire));
KsumFor DUT5 (.clk(clk), .clr_f(clr_f_wire), .load(load_wire), .K(K_wire), .K_out(K_wire));

limites_j DUT6( .sizeY(sizeY_wire), .sizeX(sizeX_wire) , .K(K_wire), .inicio(inicio_wire), .fin(fin_wire));
jFor DUT7( .clk(clk), .clr_j(clr_j_wire), .load_j(load_j_wire), .inicio(inicio_wire), .j(j_wire),.j_out(j_wire));
   
comparaj_fin DUT8( .j(j_wire), .fin(fin_wire), .jfin( jfin_wire));
   
addressXYZ DUT9( .clk(clk), .j(j_wire), .K( K_wire), .addrX(memX_addr) , .addrY(memY_addr), .addrZ(memZ_addr));  
oper_convolution DUT10 ( .clk(clk), .dataX(dataX), .dataY(dataY), .clr_z(clr_z_wire), .load_z/*load_z*/(load_z_wire), .dataZ_in(dataz_wire), .dataZ_out(dataz_wire));
   
writez_out DUT11( .en_write(en_write_wire), .writeZ(writeZ), .dataZin(dataz_wire), .dataZout(dataZ) );  

lim_inf_shape DUT12 (.clk(clk), .sizeX(sizeX_wire), .sizeY(sizeY_wire), .inf(inf_wire));
lim_sup_shape DUT13 (.clk(clk), .sizeX(sizeX_wire), .sizeY(sizeY_wire), .sup(sup_wire));


compKShape DUT14 ( .K(K_wire), .inf(inf_wire),.sup(sup_wire), .comp_out_shape(comp_out_shape_wire));





endmodule
	



