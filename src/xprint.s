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


//  xprint.s (printf fuctions)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


//      eXtended PRINT
//
//  All paramaters on stack
//  SP[0]   Return Address
//  SP[2]   Format String
//  SP[4+]  Extra Parameters
//-------------------------------------
.global xprint
.text
xprint: mov.b   #0,&lcdChar // start of screen
	
	    push    r11
	
        mov.w	4(r1),r14	// SP[4] -> r14	
        mov.w	r1,r12		// SP -> r12
xp0:	
        mov.b   @r14+,r15
        tst.b   r15
        jz      xp2
        cmp.b   #'%',r15	// Is special?
        jeq	    xp3
xp1:	call    #lcdPut
	    jmp     xp0
xp2:	pop     r11
	    ret	                //exit	

xp3:	mov.b   #0,r13		//r13 digits
        mov.b	@r14+,r15	// get flags
        cmp.b	#'%',r15	//'%'?
        jeq	    xp1	
	
        incd.w	r12         // inc 'stack pointer'	

        clr.w   r11
        mov.b   #' ',r6
        cmp.b   #'0',r15	//zero filled
        jne     xp5
        mov.w   #'0',r6
xp4:    mov.b   @r14+,r15	//get width
xp5:    cmp.b   #'9'+1,r15
        jge     xp7
        sub.b   #'0',r15
        mov.w   r15,r11

xp6:	mov.b   @r14+,r15
	
xp7:	cmp.b   #'c',r15	// If character
        jne     xp8
        mov.w   4(r12),r15	//load char from stack
        jmp     xp1		    //-> print character
xp8:    cmp.b   #'s',r15
        jeq     xpC
	
xp9:	cmp.b   #'u',r15
        mov.w   #10,r13
        jeq     xpA
        cmp.b   #'X',r15
        mov.w   #16,r13
        jeq     xpA
        jmp     xp2	        // abort
xpA:	call    #xitoa
xpB:	jmp     xp0
	
xpC:	mov.w   4(r12),r11	//get &str from stack
xpD:	mov.b   @r11+,r15	//get r15 = *str++
        tst.b   r15		    //is not \0
        jz      xp0
        call    #lcdPut	    //gogo
        jmp     xpD 	    //loop time

printfu:ret



//      eXtended Integer TO Array
//      (Only called from xprint)
//    
//  r13 radix                    
//  r12 SP                       
//  r15 putc                     
//  r14 used                                       
//  r11 diits                    
//-------------------------------------
.text
xitoa:  mov.w   #0,r8
        mov.w   #0,r5
        mov.w   4(r12),r9

x1: 	mov.w   #16,r7	    //16bit?
        mov.w   #0,r10
x2: 	clrc
        rla.w   r9
        rlc.w   r10
        cmp.w   r13,r10     // compar radix
        jlo     x3

        sub.w   r13,r10	    //subtract radix from r10
        inc.w   r9
x3: 	dec.w   r7
        jnz     x2
        cmp.b   #10,r10	    // is numeral '0' - 'F'
        jlo     x4
        add.b   #7,r10
x4:	    add.b   #'0',r10
        push.b  r10
        inc.w   r8
        tst.w   r9
        jnz     x1

x5: 	cmp.w   r11,r8
        jhs     x6
        push    r6
        inc.w   r8
        jmp     x5	


x6:	    pop.b   r15	        //flush stack
        call    #lcdPut
        dec.w   r8
        jnz     x6
        ret

