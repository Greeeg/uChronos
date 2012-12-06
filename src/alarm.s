#include "lcd.h"

.data
almStr: .string "%2u%02u%s"
strd:	.string "TIME"
	.byte 0
      
.text  
.global almInit
.global almEv

almInit:
	mov.w   #COL3,r15
        mov.w   #SEG_ON,r14
        call    #lcdSym
        
        mov.w   #ICON_ALARM,r15
        call    #lcdSym
	//	ret
almDis: 
        mov.w   #0,r15
        
		push.w	#strd        
        push.w  #30
		push.w	#6		
        push.w  #almStr
        
        call    #xprint
        
        add.w   #8,r1		; Restore SP
        
        ret
        

almEv: 
        ret
        
        
        
