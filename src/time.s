//  Includes
//-------------------------------------
#include <cc430f6137.h>
#include "lcd.h"

.section .data
timeStr: 
        .string "%02u%02u%s%2u" 
          
dow:    
        .string "SUN"
        .string ";ON"	; |JEd slightly more realistic W
        .string "TUE"
        .string ":ED"	; ; more realistic M when used with extra 1
        .string "THU"
        .string "FRI"
        .string "SAT"
        .string "NUL"

                
.section .text
.global timeInit
.global timeEv
timeInit:
		mov.w   #COL3,r15
        mov.w   #SEG_ON+BLINK,r14
        call    #lcdSym
        
        mov.w   #SEG_ON,r14
        
        mov.w   #DP1,r15
        call    #lcdSym
        call    #timeDis
		ret

timeEv:
        ret

timeDis: 
        ; Set Seg1, when DOW == 1 || dow == 3
        mov.w   #SEG_OFF,r14
        
        cmp.b   #1,&RTCDOW
        jeq     oneSet
        cmp.b   #3,&RTCDOW
        jne     oneClr
oneSet: mov.w   #SEG_ON,r14
oneClr: mov.w   #SYM_ONE,r15
        call    #lcdSym
        
        
       // mov.w   #timeStr,r14
       // mov.w   #dow,r13
        
        
        
        
        
        mov.b   &RTCDOW,r14

        rla r14
        rla r14
        
        add.w   #dow,r14
        
        mov.b   &RTCDAY,r15     //simple byte>int hack
        push.w  r15              // %2u
        push.w  r14             // %s
        mov.b   &RTCMIN,r15     //simple byte>int hack
        push.w  r15             // %02u
        mov.b   &RTCHOUR,r15    //simple byte>int hack
        push.w  r15             // %02u
        
        push.w  #timeStr        // Str :D
        
        call    #xprint
        
        add.w   #10,r1
        
        
     //   jmp timeDis

        
        
        ret
        
        
        
        
