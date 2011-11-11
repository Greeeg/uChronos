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


.global adcConv
.text
//r15
//r14
//r13
adcConv://push.w  r12
        push.w  r14
        /* Initialize the shared reference module */ 
        bis.w   #REFMSTR+REFON,r15
        bis.w   r15,&REFCTL0            ; Enable internal reference
  
        /* Initialize ADC12_A */ 
        bis.w   #ADC12ON,r14
        mov.w   r14,&ADC12CTL0		    ; Set sample time 
        mov.w   #ADC12SHP,&ADC12CTL1    ; Enable sample timer
        
        bis.w   #ADC12SREF_1,r13
        mov.w   r13,&ADC12MCTL0         ; ADC input ch A10 => temp sense 
       ; mov.w   #0x001,&ADC12IE         ; ADC_IFG upon conv result-ADCMEMO
    
        mov.w   #0x000F,r14             ; settling time
adc1:   dec.w   r14
        jnz     adc1
        
        bis.w   #ADC12ENC,&ADC12CTL0
        
        bis.w   #ADC12SC,&ADC12CTL0
        
adc2:   cmp.w   #1,&ADC12IFG
        jne     adc2
        
        pop.w   r14
        bis.w   #ADC12ENC+ADC12SC,r14   
        bic.w   r14,&ADC12CTL0          ; Shut down ADC
        
        bic.w   r15,&REFCTL0            ; Turn off ref
        
        mov.w   &ADC12MEM0,r15
        
        mov.w   #0,&ADC12IFG
        
        
        //pop.w   r12
        ret


.text
.global adcBatt
adcBatt:mov.w   #REFVSEL_1,r15
        mov.w   #ADC12SHT0_12,r15
        mov.w   #ADC12INCH_11,r15
        
        call    #adcConv
        
        // div by 9
        mov.w   #9,r14
        call    #div
        
        mov.w   #4,r14
        call    #mul
        
        //clr.w   r13
        mov.w   r15,r13
        
        
        mov.w   &volt,r15
        mov.w   #8,r14
        call    #mul
        
        
        add.w   r13,r15
        mov.w   #10,r14
        call    #div
        
        mov.w   r15,&volt
        
        ret
