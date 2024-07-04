// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.


//#include "firmware.h"
#include <stdbool.h>
#include <stdint.h>
#include <string.h>

#define reg_spictrl (*(volatile uint32_t*)0x02000000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define reg_leds (*(volatile uint32_t*)0x03000000)


#define MEM_TOTAL 0x1000 /* 128 KB */
#define AIP_IP_IPDUMMY 0x80000100
/**/

#define AIP_IP_IPCONVOLUTION 0x80000300
#define AIP_MEMX       0
#define AIP_ADDRMEMX   1
#define AIP_MEMY       2
#define AIP_ADDRMEMY   3
#define AIP_MEMZ       4
#define AIP_ADDRMEMZ   5
#define AIP_CONFIG1    6
#define AIP_AonfReg1   7
#define AIP_STATUS    30
#define AIP_ID        31





#define AIP_DATAOUT  0 //80000300
#define AIP_DATAIN   1 //80000304
#define AIP_CONFIG   2 
#define AIP_START    3 //8000030C

#define MAX_DATA     8
#define SIZE_MEMZ    32

typedef struct
{
    uint32_t aip_dataOut;
    uint32_t aip_dataIn;
    uint32_t aip_config;
    uint32_t aip_start;
} aip_regs;

typedef struct
{
	uint32_t memx;
	uint32_t addrmemx;
	uint32_t memy;
	uint32_t addrmemy;
	uint32_t config1;
	uint32_t AonfReg1;
	uint32_t status;
} aip_regs1;
void putchar(char c);
void print(const char *p);
void print_hex(uint32_t v, int digits);
void print_dec(uint32_t v);
uint8_t aip_writeData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size);
uint8_t aip_readData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size);
uint8_t aip_start (aip_regs * port);

char *logo =

    "              vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv\n"
    "                  vvvvvvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv\n"
    "rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvv  \n"
    "rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvv    \n"
    "rr                vvvvvvvvvvvvvvvvvvvvvv      \n"
    "rr            vvvvvvvvvvvvvvvvvvvvvvvv      rr\n"
    "rrrr      vvvvvvvvvvvvvvvvvvvvvvvvvv      rrrr\n"
    "rrrrrr      vvvvvvvvvvvvvvvvvvvvvv      rrrrrr\n"
    "rrrrrrrr      vvvvvvvvvvvvvvvvvv      rrrrrrrr\n"
    "rrrrrrrrrr      vvvvvvvvvvvvvv      rrrrrrrrrr\n"
    "rrrrrrrrrrrr      vvvvvvvvvv      rrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrr      vvvvvv      rrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrr      vv      rrrrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrrrr          rrrrrrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrrrrrr      rrrrrrrrrrrrrrrrrrrr\n"
    "rrrrrrrrrrrrrrrrrrrrrr  rrrrrrrrrrrrrrrrrrrrrr\n"
    "\n"
    "       PicoSoC with DSP Accelerators\n\n";

void main(void)
{
	//reg_uart_clkdiv = 104; //12 MHz/ 115200 Baud SIMULAR
	//reg_uart_clkdiv = 104;//(50000000/115200); //50 MHz/ 115200 Baud AL FPGA  434
	reg_uart_clkdiv = 434;
	//print("Booting..\n");

	reg_leds = 63;
	//set_flash_qspi_flag();

	reg_leds = 127;
	
	print("Lets Configure the IPDUMMY Module!\n");
		
	uint32_t i = 0;
    	//uint32_t data [MAX_DATA] ;
	uint32_t data_read[MAX_DATA];

	data_read[0] = 0;
    data_read[1] = 0;
    data_read[2] = 0;
	data_read[3] = 0;
	data_read[4] = 0;
	data_read[5] = 0;
	data_read[6] = 0;
	data_read[7] = 0;

    	//aip_regs * aipTest = (aip_regs *)AIP_IPDUMMY;
    uint32_t *ptr_C = (uint32_t*)AIP_IP_IPDUMMY;
    uint32_t *ptr = (uint32_t*)AIP_IP_IPCONVOLUTION;
    /*	
	*ptr_C   = 0x0000BEAF;
	*(ptr_C+1) = 0x000BEAF0;
	*(ptr_C+2) = 0x00BEAF00;
	*(ptr_C+3)= 0x0BEAF000;

	*ptr_C     = 0x0000BEAF;
	*(ptr_C+1) = 0x000BEAF0;
	*(ptr_C+2) = 0x00BEAF00;
	*(ptr_C+3)= 0x0BEAF000;*/


	print("Reading IPID !\n");
	uint32_t IPID1 = 0;
	*(ptr + AIP_CONFIG) = 31;
	IPID1 = *(ptr + AIP_DATAOUT);
	print_hex(IPID1,8);
	print("\n");
	print("\n");
	
	print("write Memx!\n");

	//MEMORIA X
	*(ptr + AIP_CONFIG) = 1;  // AIP_ADDRMEMX   1
	*(ptr + AIP_DATAIN) = 0; //  
	*(ptr + AIP_CONFIG) = 0;  // AIP_MEMX  0
	*(ptr + AIP_DATAIN) = 1; // 
	*(ptr + AIP_DATAIN) = 2; // 
	*(ptr + AIP_DATAIN) = 3; //
	*(ptr + AIP_DATAIN) = 4; //

	
	print("write MemY!\n");
	//MEMORIA Y
	*(ptr + AIP_CONFIG) = 3;  // AIP_ADDRMEMY
	*(ptr + AIP_DATAIN) = 0; // 
	*(ptr + AIP_CONFIG) = 2;  //  AIP_MEMY 2
	*(ptr + AIP_DATAIN) = 1; // 
	*(ptr + AIP_DATAIN) = 2; // 
	*(ptr + AIP_DATAIN) = 3;

	print("write CONFIG!\n");
	//CONF
	*(ptr + AIP_CONFIG) = 7;  // AIP_AonfReg1
	*(ptr + AIP_DATAIN) = 0; // 
	*(ptr + AIP_CONFIG) = 6;  // AIP_CONFIG1
	*(ptr + AIP_DATAIN) = 400;//268;//402; // Clean  [self.__opCode], 1, 7, self.__addrs)ptr
	
	print("Reading STATUS !\n");
	uint32_t STATUS = 0;
	*(ptr + AIP_CONFIG) = 30;
	STATUS = *(ptr + AIP_DATAOUT);
	print_hex(STATUS,16);
    print("\n");

	print("Start convolution !\n");
	*(ptr + AIP_START)  = 1;

	print("\n");
	print("\n");	

//====================================================================
	*(ptr + AIP_CONFIG) = 5;  // AIP_ADDRMEMZ   1
	*(ptr + AIP_DATAIN) = 0; // 
	*(ptr + AIP_CONFIG) = 4;  // AIP_MEMZ
    uint32_t ZVALUE  = 0x0a0a0a0a;
	print("Reading MEMZ !\n");

	ZVALUE =  *(ptr + AIP_DATAOUT);
	print_hex(ZVALUE,8);
	ZVALUE =  *(ptr + AIP_DATAOUT+1);
	print_hex(ZVALUE,8);
	ZVALUE =  *(ptr + AIP_DATAOUT+1);
	print_hex(ZVALUE,8);
	ZVALUE =  *(ptr + AIP_DATAOUT+2);
	print_hex(ZVALUE,8);
	ZVALUE =  *(ptr + AIP_DATAOUT+2);
	print_hex(ZVALUE,8);
	ZVALUE =  *(ptr + AIP_DATAOUT+2);
	print_hex(ZVALUE,8);
/*
	for (i = 0; i < SIZE_MEMZ; i++){  
		     
		ZVALUE =  *(ptr + AIP_DATAOUT);		
		print_hex(ZVALUE,8);
	
}
*/
//////////////////////////////////////////////////////////////////////////////////////////////



/*

 
	print("Configuring IPDummy !\n");
	*(ptr_C + AIP_CONFIG) = 3;  // AMEMIN_DDSParam,0b00011,1,W,We Pointer of MMEMIN_DDSParam
	*(ptr_C + AIP_DATAIN) = 0; // Ste ptr to 0
	*(ptr_C + AIP_CONFIG) = 2;  // CFG,MMEMIN_DDSParam,0b00010,8,W,DDS parameters
	print("Configuring IPDummy  !\n");
	*(ptr_C + AIP_DATAIN) = 0x03AFFFFF; // 

	*(ptr_C + AIP_DATAIN) = 0x002FFFFF; // 
	*(ptr_C + AIP_DATAIN) = 0x00000400; // 
	*(ptr_C + AIP_DATAIN) = 0x00000400; // 
	*(ptr_C + AIP_DATAIN) = 0x0000000a; // 
	*(ptr_C + AIP_DATAIN) = 0x00000020; // 
	*(ptr_C + AIP_DATAIN) = 0x00000008; // 
	

	*(ptr_C + AIP_DATAIN) = 0x00000010; // 
	*(ptr_C + AIP_CONFIG) = 6; // writing CCONFREG just for testing

    	for (i = 0; i < MAX_DATA; i++){
        	//x = (char*)data[i];
		print("\n");
		//print_uint32(i);
		//ptr_C = &data[i];
		//*ptr_C = i;
		//*(ptr_C + AIP_CONFIG) = 0; // CFG,DATAIN,0b00000,64,W,Mem Data In
		*(ptr_C + AIP_DATAIN) = (uint32_t) (0x10 + i);

    	}
    	*(ptr_C + AIP_START)  = 1;
	print("aip_writeData!\n");

	//for (i = 0; i < 100; i++){
	for (i = 0; i < 100000; i++){
		__asm__ volatile ("nop");//asm volatile("");    	        
	}
        


    	reg_leds = 31;
	

	reg_leds = 1;
	print("\n");

	while (1)
	{
		if(reg_leds<128)
			reg_leds = reg_leds + 1;
		else
			reg_leds = 1;	
		//for (int rep = 200; rep > 0; rep--)
			for (int rep = 100000; rep > 0; rep--)
		{
			__asm__ volatile ("nop");//asm volatile("");
		}
	}



/////////////////////////////////////////////////////////////////////////////////////////////


*/



}

// --------------------------------------------------------


void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}

void print_hex(uint32_t v, int digits)
{
	for (int i = 7; i >= 0; i--) {
		char c = "0123456789abcdef"[(v >> (4*i)) & 15];
		if (c == '0' && i >= digits) continue;
		putchar(c);
		digits = i;
	}
}


void print_dec(uint32_t v)
{
	if (v >= 1000) {
		print(">=1000");
		return;
	}

	if      (v >= 900) { putchar('9'); v -= 900; }
	else if (v >= 800) { putchar('8'); v -= 800; }
	else if (v >= 700) { putchar('7'); v -= 700; }
	else if (v >= 600) { putchar('6'); v -= 600; }
	else if (v >= 500) { putchar('5'); v -= 500; }
	else if (v >= 400) { putchar('4'); v -= 400; }
	else if (v >= 300) { putchar('3'); v -= 300; }
	else if (v >= 200) { putchar('2'); v -= 200; }
	else if (v >= 100) { putchar('1'); v -= 100; }

	if      (v >= 90) { putchar('9'); v -= 90; }
	else if (v >= 80) { putchar('8'); v -= 80; }
	else if (v >= 70) { putchar('7'); v -= 70; }
	else if (v >= 60) { putchar('6'); v -= 60; }
	else if (v >= 50) { putchar('5'); v -= 50; }
	else if (v >= 40) { putchar('4'); v -= 40; }
	else if (v >= 30) { putchar('3'); v -= 30; }
	else if (v >= 20) { putchar('2'); v -= 20; }
	else if (v >= 10) { putchar('1'); v -= 10; }

	if      (v >= 9) { putchar('9'); v -= 9; }
	else if (v >= 8) { putchar('8'); v -= 8; }
	else if (v >= 7) { putchar('7'); v -= 7; }
	else if (v >= 6) { putchar('6'); v -= 6; }
	else if (v >= 5) { putchar('5'); v -= 5; }
	else if (v >= 4) { putchar('4'); v -= 4; }
	else if (v >= 3) { putchar('3'); v -= 3; }
	else if (v >= 2) { putchar('2'); v -= 2; }
	else if (v >= 1) { putchar('1'); v -= 1; }
	else putchar('0');
}

// --------------------------------------------------------
uint8_t aip_configuration(aip_regs * port, uint8_t config, uint32_t * data, uint32_t size)
{
    if(!size) return 1;

    port->aip_config = config;
    
    for (uint32_t i = 0; i < size; i++)
    {
        port->aip_dataIn = *(data+i);
    }
    
    return 0;
}



uint8_t aip_writeData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size)
{
    if(!size) return 1;

    port->aip_config = config;
    
    for (uint32_t i = 0; i < size; i++)
    {
        port->aip_dataIn = *(data+i);
    }
    
    return 0;
}

uint8_t aip_readData (aip_regs * port, uint8_t config, uint32_t * data, uint32_t size)
{
    if(!size) return 1;

    port->aip_config = config;
    
    for (uint32_t i = 0; i < size; i++)
    {
        *(data+i) = port->aip_dataOut;
    }
    
    return 0;
}

uint8_t aip_start (aip_regs * port)
{
    port->aip_start = 0x1;

    __asm__ volatile ("nop");//asm volatile("");

    //port->aip_start = 3;
        
    return 0;
}

