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


//  lcd.s (Chronos lcd Driver)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


#include <cc430f6137.h>


// 7-segment character bit assignments
#define SEG_A                	(BIT4)
#define SEG_B                	(BIT5)
#define SEG_C                	(BIT6)
#define SEG_D                	(BIT7)
#define SEG_E                	(BIT2)
#define SEG_F                	(BIT0)
#define SEG_G                	(BIT1)


lcdTable:
    .byte 0xf5, 0x60, 0xb6, 0xf2, 0x63, 0xd3, 0xd7, 0x70, 0xf7, 0xf3 
    .byte 0xe4, 0x71, 0x13, 0x82, 0x00, 0x36, 0x00, 0x77, 0xc7, 0x86     
    .byte 0xe6, 0x97, 0x17, 0xf3, 0x47, 0x04, 0xf0, 0x83, 0x85, 0x75            
    .byte 0x46, 0xc6, 0x37, 0x73, 0x06, 0xd3, 0x87, 0xc4, 0xc4, 0xe7    
    .byte 0x67, 0xe3, 0xb6  
    
lcdPos:
    .byte	1,2,3,5,11,10,9,8,7


.global lcdClr
lcdClr: bis.b	#LCDCLRBM+LCDCLRM,&LCDBMEMCTL	// Clear entire display memory
        ret


//----------------------------
// Basic Swap nibble function |
// Input byte r15
//----------------------------
swpn:   push.w	r12     //temp storage
        mov.w	r15,r12
        rla     r15
        rla     r15
        rla     r15
        rla     r15
        rra     r12
        rra     r12
        rra     r12
        rra     r12
        bic.b	#0x0F,r15
        bis.b	r12,r15
        pop.w	r12
        ret



//------------------------------\
// Put ascii character on LCD   |
// r15: character 		        |
// r14: position 0-9	    	|
// r13: temp		        	|
// r12: mask		         	|
//------------------------------/
.global lcdPut
lcdPut:	
        cmp.b   #' ',r15            // Space?
        jeq     putEnd              // Early out
        cmp.b	#9,&lcdChar	        // Too high?
	    jhs	    putEnd              // Early out
	    
	    sub.w	#'0',r15            // ascii -> lookup
	    push.w 	r14                 
	    push.w	r13
	    push.w	r12
	    mov.b	&lcdChar,r14        // need this later on
	    mov.b	lcdTable(r15),r13
	    mov.b	r13,r15
	    mov.b	#0xF7,r12
	    cmp.w	#4,r14
	    jlo	    put0
	    call	#swpn               // swap nibble is char is bottom line
	    mov.b	#0x7F,r12           // 
put0:	mov.b	lcdPos(r14),r13
	    bic.b	r12,0x0A20(r13)		// clear char space
	    bis.b	r15,0x0A20(r13)		// print new char
	    pop.w	r12
	    pop.w	r13
	    pop.w	r14
putEnd:	inc.b	&lcdChar
	    ret


//r15 input byte
.global lcdSym
lcdSym: push    r13
        cmp.w   #0xC,r15            // spread?
        jlo     sym0
        mov.b   r15,r13             // mask stored in r13
        swpb    r15                 // get offset +1
        bic.w   #0xFF00,r15         // clear mask
        dec.b   r15                 // get addr offset
        jmp     sym1                // do something with the mask and addr
        
        // Syms that are spread across addrs
sym0:   mov.b   #0x08,r13           // mask 0-5
        cmp.b   #0x6,r15            // flip data?
        jlo     sym1
        mov.b   #0x80,r13           // mask 7-B
        
sym1:   bit.b   #0x04,r14           // blink?
        jz      sym2               
        bis.b   r13,0x0A40(r15)     // set blinking mem
        jmp     sym3                
sym2:   bic.b   r13,0x0A40(r15)     // clear blinking mem

sym3:   bit.b   #0x02,r14           // SEG_OFF?
        jnz     sym5
sym4:   bis.b   r13,0x0A20(r15)
        jmp     end
sym5: 
        bic.b   r13,0x0A20(r15)
end:    pop     r13
        ret

        
	
	
	
