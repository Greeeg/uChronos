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

.section .bss
.global button
.global butM1
.global butM2
.global butBL
.global butS1
.global butS2
button:
butS2:
	.word 0		;S2 - 0x01
butM2:
	.word 0		;M2 - 0x02
butM1:
	.word 0		;M1 - 0x04
butBL:
	.word 0		;BL - 0x08
butS1:
	.word 0		;S1 - 0x10
	
