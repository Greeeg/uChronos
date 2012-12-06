#include <cc430f6137.h>

.global TA1Init
.global TA1Int
.section .bss
buttonValues:
	.ds 5
butonClone:
	.ds 5

.section .text
TA1Init:
		mov.w	#TASSEL_1+ID_0+MC_1+TACLR,&TA1CTL
		mov.w	#256,&TA1CCR0
		mov.w	#CCIE,&TA1CCTL0
		
		ret
		
TA1Int:
	
		push 	r15
		push 	r14
		mov.b	#1,r15
		clr.w	r14
cycle:	bit.b	r15,&P2IN
		rrc.w	buttonValues(r14)
		rra.w	r15
		incd.w	r14
		cmp.w	#10,r14
		jne		cycle
		
		pop r14
		pop r15
		
		add.w	#256,&TA1CCR0
		reti