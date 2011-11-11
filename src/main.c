//=============================================================================|
//    Copyright (c) 2011, Greg Davill
//    All rights reserved.
//
//	  Redistribution and use in source and binary forms, with or without 
//	  modification, are permitted provided that the following conditions 
//	  are met:
//	
//	    Redistributions of source code must retain the above copyright 
//	    notice, this list of conditions and the following disclaimer.
//	 
//	    Redistributions in binary form must reproduce the above copyright
//	    notice, this list of conditions and the following disclaimer in the 
//	    documentation and/or other materials provided with the   
//	    distribution.
//	 
//	  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
//	  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
//	  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//	  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
//	  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//	  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
//	  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//	  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//	  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
//	  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
//	  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//=============================================================================|


//      Main.c
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


//  Includes
//-------------------------------------
#include <cc430f6137.h>
#include "lcd.h"
#include "xprint.h"
#include "global.h"
#include "adc.h"

//  Global Variables
//-------------------------------------
char lcdChar;
int temp;
int volt = 300;

int main(void)
{
	init();
	
    
	
	lcdChar = 0;
//	xprint("0430");

    
   // 
    lcdSym(SYM_BATT,SEG_ON);
    lcdSym(DP1,SEG_ON);
    
    lcdSym(COL3,BLINK | SEG_ON);
    
	while(1)
	{

        adcBatt();
        xprint("%2u%02u  %03u",RTCHOUR,RTCMIN,volt);
        __bis_SR_register(LPM0_bits + GIE);

	}
}



__attribute__((interrupt(RTC_VECTOR))) 
void rtcInt(void)
{
    RTCIV = 0;
   LPM4_EXIT;
}

__attribute__((interrupt(PORT2_VECTOR))) 
void keyInt(void)
{

    __disable_interrupt();
    P2IFG = 0x00; 	
    P2IE  = 0x1F;	
    __enable_interrupt();


    LPM4_EXIT;
}



