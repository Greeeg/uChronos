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


//  math.s (math fuctions)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Integer-Integer division using Algorithm described in Hamacher
.text
.global div
div:    mov.w   #16,R11
        clr.w   R10
start:  rla.w   r15
        rlc.w   R10
        bis.w   #1, r15
        sub.w   R14,R10
        jge     loc1
        add.w   R14,R10
        bic.w   #1, r15
loc1:   dec.w   R11
        cmp.w   #0,R11
        jnz     start
        ret
        
.text
.global mul     
mul:    mov.w   r15,r4
test:   dec.w   r14
        jz      end
        add.w   r4,r15
        jmp     test
end:    ret
