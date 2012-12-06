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
//#include "xprint.h"
#include "global.h"
#include "core.h"
#include "adc.h"
#include "../hardware.h"

//  Global Variables
//-------------------------------------
int adcVal,adcVolt=300,adcDegree=150;

volatile int wakeEvent;
volatile char buttonMask;



int main(void)
{
	init();


	while(1)
	{
		

		coreEvent();
       // xprint("%2u%02u%05u",RTCHOUR,RTCMIN,adcDegree);
        
		LPM3;

	}
}



__attribute__((interrupt(TIMER1_A0_VECTOR)))
void Timer1_A0_Int(void)
{
	asm("jmp TA1Int");
}



__attribute__((interrupt(ADC12_VECTOR)))
void adc12Int(void)
{
   adcVal = ADC12MEM0;
  // LPM4_EXIT;
}


__attribute__((interrupt(RTC_VECTOR))) 
void rtcInt(void)
{
    RTCIV = 0;
	wakeEvent = EVENT_TICK;
   	__bic_SR_register_on_exit(LPM3_bits);
}

__attribute__((interrupt(PORT2_VECTOR))) 
void keyInt(void)
{

    __disable_interrupt();
	buttonMask = P2IFG;   

	

	P2IFG = 0x00; 	
    P2IE  = 0x1F;
    wakeEvent = EVENT_BUTTON;
    LPM3_EXIT;
}



