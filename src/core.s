#include "core.h"
#include "../hardware.h"


.section .bss
.global coreActive

coreActive:	.byte   0   ; ID 0 - 4
	.byte   0   ; wakeup event.

            
.section .data
; Init Functions (configure lit LCD segs etc)
coreInit:
	.word   timeInit 	; Time
	.word   tmrInit    	; Timer
	.word   almInit    	; Alarm

; Device wakeup
coreWakeEvent: 
    .word   timeEv 	; Time
    .word   tmrEv     	; Timer
	.word   almEv   	; Alarm

.section .text
.global coreOpen
.global coreNext
.global coreEvent
coreEvent:
		cmp.w	#EVENT_BUTTON,&wakeEvent
		jne		evTick
		
		cmp.b	#KEY_M1,&buttonMask
		jne		evNull
		call	#coreNext
evTick:		
		//cmp.w 	#EVENT_TICK,&wakeEvent
		//jne		evNull
		//push.w	r4
		//mov.w	&coreActive,r4
		//jmp 	coreDisplay
evNull:
		push.w 	r15
		push.w 	r14
		push.w 	r13
		push.w 	r12
		mov.w 	&wakeEvent,r15
		mov.b 	&buttonMask,r14
		mov.w	&coreActive,r13
		
		rla		r13
		mov.w	coreWakeEvent(r13),r12
		call	r12
		pop.w 	r12
		pop.w 	r13
		pop.w 	r14
		pop.w 	r15
		ret

coreNext: 
		inc.w   &coreActive
        cmp.w	#3,&coreActive
		jne		coreOpen
		clr.w	&coreActive

coreOpen:
		call	#lcdClr
		
		push.w	r4
		mov.w	&coreActive,r4
		
		rla		r4
		mov.w	coreInit(r4),r15
		call	r15

//coreDisplay:

	//	mov.w	coreDis(r4),r15
	//	call	r15

		pop.w 	r4
		ret