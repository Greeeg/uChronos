;==============================================================================|
;     Copyright (c) 2011, Greg Davill
;     All rights reserved.
; 
; 	  Redistribution and use in source and binary forms, with or without 
; 	  modification, are permitted provided that the following conditions 
; 	  are met:
; 	
; 	    Redistributions of source code must retain the above copyright 
; 	    notice, this list of conditions and the following disclaimer.
; 	 
; 	    Redistributions in binary form must reproduce the above copyright
; 	    notice, this list of conditions and the following disclaimer in the 
; 	    documentation and/or other materials provided with the   
; 	    distribution.
; 	 
; 	  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
; 	  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
; 	  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
; 	  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
; 	  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
; 	  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
; 	  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
; 	  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
; 	  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
; 	  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
; 	  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
; 
;==============================================================================|


#include <cc430f6137.h>


.global adcConv
.text
; r15
; r14
; r13
adcConv:; push.w  r12
        push.w  r14
        /* Initialize the shared reference module */ 
        bis.w   #REFMSTR+REFON,r15
        bis.w   r15,&REFCTL0            ; Enable internal reference
  
        /* Initialize ADC12_A */ 
        bis.w   #ADC12ON,r14
        mov.w   r14,&ADC12CTL0		    ; Set sample time 
        mov.w   #ADC12SHP,&ADC12CTL1    ; Enable sample timer
        
        mov.w   #ADC12RES_2,&ADC12CTL2
        
        bis.w   #ADC12SREF_1,r13
        mov.w   r13,&ADC12MCTL0         ; ADC input ch A10 => temp sense 
        mov.w   #0x01,&ADC12IE          ; ADC_IFG upon conv result-ADCMEMO
    

        mov.w   #0x00FF,r14             ; settling time
adc1:   dec.w   r14
        jnz     adc1

        
        bis.w   #ADC12ENC,&ADC12CTL0
        
        bis.w   #ADC12SC,&ADC12CTL0
        
adc2:   bis.w   #LPM4_bits+GIE,r2           ; Sleep Time
        
        pop.w   r14
        bis.w   #ADC12ENC+ADC12SC,r14   
        bic.w   r14,&ADC12CTL0          ; Shut down ADC
        
        bic.w   r15,&REFCTL0            ; Turn off ref
        
        ret


.text
.global adcBatt
adcBatt:mov.w   #REFVSEL_1,r15
        mov.w   #ADC12SHT1_11,r14
        mov.w   #ADC12INCH_11,r13
        
        call    #adcConv
        
        ;   The basic ADC -> volts is as follows
        ;   ADCVAL * 2 * (ref_v) / 40.96
        ;   (4/40.96) * 65536 == 6400
        ;   Which is equal to (4/40.96) << 16
        ;   Using the 32bit MPY we can do this easily.
        mov.w   &adcVal,&MPY
        mov.w   #6400,&OP2
        
        ;   take second word as we (<<16)
        ;   Store as format X.xx (v)
        mov.w   &RES1,&adcVolt
        
        

        
        ret
        
.text
.global adcTemp
adcTemp:mov.w   #REFVSEL_0,r15
        mov.w   #ADC12SHT0_8,r14
        mov.w   #ADC12INCH_10,r13
        
        call    #adcConv
     //   
      //  add.w   #-1855,&adcVal
        
           
        
    //   mov.w   &adcVal,&MPY32L
    //   mov.w   #0,&MPY32H
    //    mov.w   #41184,&OP2L
   //     mov.w   #1,&OP2H


            
        ;   take second word as we (<<16)
     //   mov.w   &RES1,&adcDegree
      mov.w   &adcVal,&adcDegree
        
 
        
        ret
