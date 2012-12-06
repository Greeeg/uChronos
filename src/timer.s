#include "lcd.h"

.data
tmrStr: .string "TN%02u%01u%02u%02u"
		.byte 0

      
.text  
.global tmrInit
.global tmrEv

tmrInit:
	mov.w   #COL3,r15
        mov.w   #SEG_ON,r14
        call    #lcdSym
        
        mov.w   #COL1,r15
        call    #lcdSym
        
        
        mov.w   #COL2,r15
        call    #lcdSym
        
        mov.w   #ICON_TIMER,r15
        call    #lcdSym
        call    #tmrDis
	ret

tmrEv:
        ret

tmrDis: 
        mov.w   #0,r15
        
        push.w  #0
        push.w  #0
        push.w  #0
        push.w  #0
        push.w  #tmrStr
        
        call    #xprint
        
        add.w   #10,r1		; Restore SP
        
        
        
        ret
        
        
        
        
