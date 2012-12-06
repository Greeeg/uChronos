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


#include <cc430f6137.h>
#include "../config.h"
#include "../hardware.h"


/*
	__even_in_range
    if((r15 & 1) || r15 >= r14)
        return 0 
    else
        return r15
*/
.text 

.global __even_in_range
__even_in_range:
        bit.b   #0,r15             //test: __value is even?
        jnz     NotValid
        cmp.b   r14,r15            // test: __value in range?
        jlo     Exit
NotValid:                       // not valid set r15 = 0 else leave passed paremeter in r15 to be returned
        mov.b   #0,r15
Exit:
        ret



.text
.global init
init:	
	    mov.w	#WDTPW+WDTHOLD,&WDTCTL
	
pmaInit:dint
	    
	    //Port mapping
	    mov.w	#PMAPKEY,&PMAPPWD	            //unlock PMA
	    mov.w	#PMAPRECFG,&PMAPCTL	            //allow reconfig
	
	    mov.b	#PM_TA1CCR0A,&P2MAP7            // buzzer
	    mov.b	#PM_UCA0SOMI,&P1MAP5
	    mov.b	#PM_UCA0SIMO,&P1MAP6
	    mov.b	#PM_UCA0CLK,&P1MAP7
	
	    clr.w	&PMAPPWD
	
lcdInit:bis.b	#LCDCLRBM+LCDCLRM,&LCDBMEMCTL	// Clear entire display memory
	
	    // Frame frequency = 512Hz/2/4 = 64Hz, LCD mux 4, LCD on
	    mov.w	#(LCDDIV0+LCDDIV1+LCDDIV2+LCDDIV3 )|(LCDPRE0+LCDPRE1)|LCD4MUX|LCDON,&LCDBCTL0
	
	    // LCB_BLK_FREQ = ACLK/8/4096 = 1Hz
	    mov.w	#LCDBLKPRE0|LCDBLKPRE1|LCDBLKDIV0|LCDBLKDIV1|LCDBLKDIV2|LCDBLKMOD0,&LCDBBLKCTL
	
	    bis.b	#BIT5|BIT6|BIT7,&P5SEL
	    bis.b	#BIT5|BIT6|BIT7,&P5DIR
	
	    mov.w	#0xFFFF,&LCDBPCTL0
	    mov.w	#0x00FF,&LCDBPCTL1
	
    	#ifdef USE_LCD_CHARGE_PUMP
	    mov.w	#LCDCPEN|VLCD_2_72,&LCDBVCTL
    	#endif
	
rtcInit:
    
        // Setup RTC Timer
        mov.w   #RTCTEVIE+RTCSSEL_2+RTCTEV_0+RTCMODE,&RTCCTL01  // Cal Mode, RTC1PS
                                                                // minute interrupt enable
        mov.w   #RT0PSDIV_2,&RTCPS0CTL                          // ACLK, /8, start timer
        mov.w   #RT1SSEL_2+RT1PSDIV_3,&RTCPS1CTL                // out from RT0PS, /16, start timer
        


		mov.b	#12,&RTCMON
		mov.b	#13,&RTCDAY
		mov.w	#2011,&RTCYEAR
		mov.b	#2,&RTCDOW
        mov.b   #18,&RTCHOUR
        mov.b   #8,&RTCMIN
        mov.b   #55,&RTCSEC
        
        //  Setup User buttons //
        
        bic.b   #KEY_MSK,&P2DIR
        bic.b   #KEY_MSK,&P2OUT
        bis.b   #KEY_MSK,&P2REN
        


        bis.b 	#KEY_BL,&P2DIR
        bis.b 	#KEY_BL,&P2OUT

        bic.b   #KEY_MSK,&P2IFG 
        bic.b   #KEY_MSK,&P2IES
        bis.b   #KEY_MSK,&P2IE
        
       
       
		
		
		
        mov.w   #lcdPut,&out_func

		clr.w   &coreActive
       	call	#coreOpen


		call	#TA1Init


        eint

        
        
        ret // Return
        
        
      
        
