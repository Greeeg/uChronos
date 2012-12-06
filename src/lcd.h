#ifndef _LCD_H_
#define _LCD_H_


#ifndef __ASSEMBLER__
extern char lcdChar;

void lcdPut(char);
void lcdSym(int,char);
#endif


#define SEG_ON      0x1
#define SEG_OFF     0x2
#define BLINK       0x4

#define ICON_R      0x80|0x0100
#define ICON_HEART  0x1
#define ICON_TIMER  0x2
#define ICON_ALARM  0x3

#define DP1         0x8
#define DP3         0x40|0x0100

#define SYM_PM      0x01|0x0100
#define SYM_RM      0x02|0x0100
#define SYM_UP      0x04|0x0100
#define SYM_DOWN    0x08|0x0100
#define SYM_DEGREE  0x02|0x0500
#define SYM_PERCENT 0x10|0x0500
#define SYM_FEET    0x20|0x0500
#define SYM_K       0x40|0x0500
#define SYM_SEC     0x80|0x0500
#define SYM_I       0x01|0x0700
#define SYM_M       0x02|0x0700
#define SYM_HOUR    0x04|0x0700
#define SYM_KCAL    0x10|0x0700
#define SYM_KM      0x20|0x0700
#define SYM_MI      0x40|0x0700
#define SYM_BATT    0x80|0x0700
#define SYM_MAX     0x07
#define SYM_AVG     0x09
#define SYM_TOTAL   0x0A

#define COL1        0x10|0x0100
#define COL2        0x01|0x0500
#define COL3        0x20|0x0100

#define SIG_1       0x08|0x0500
#define SIG_2       0x05
#define SIG_3       0x08|0x0700


#define SYM_ONE     0x0B

#endif // _LCD_H_
