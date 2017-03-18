

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0002)                            || ;; Engineer: 	Ezzeddeen Gazali and Tyler Starr
(0003)                            || ;; Create Date: 03/05/2017
(0004)                            || ;; File Name: 	NES_CONTROLLER_DRIVER.asm
(0005)                            || ;; Description: The following code reads an original NES controller and drives the UART on the Basys 3 
(0006)                            || ;;				board for an emulator. Additionally, drive a VGA screen to show the cureent user inputs
(0007)                            || ;; 			    and a 'pausable'/resetable timer with randomized coloring.
(0008)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0009)                            || ;; DEFINTION OF OUTPUTS
(0010)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0011)                            || ;; The Following block defines the port ids for the OUTPUTS associated with the RAT MCU.
(0012)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0013)                       064  || .EQU LEDS = 0x40
(0014)                       129  || .EQU SSEG = 0x81
(0015)                       130  || .EQU TX_CON = 0x82
(0016)                       131  || .EQU TX_DATA = 0x83
(0017)                       132  || .EQU VGA_COLUMN = 0x84
(0018)                       133  || .EQU VGA_ROW = 0x85
(0019)                       134  || .EQU VGA_COLOR = 0x86
(0020)                       135  || .EQU DIG_ADDR = 0x87
(0021)                       136  || .EQU VGA_EN = 0x88
(0022)                       137  || .EQU TIMER_CON = 0x89
(0023)                       144  || .EQU NES_ADDR = 0x90
(0024)                            || 
(0025)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0026)                            || ;; DEFINTION OF INPUTS
(0027)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0028)                            || ;; The Following block defines the port ids for the INPUTS associated with the RAT MCU.
(0029)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0030)                       032  || .EQU SWITCH_ID = 0x20
(0031)                       036  || .EQU NES_ID = 0x24
(0032)                       034  || .EQU SECOND_ID = 0x22 
(0033)                       035  || .EQU MINUTE_ID = 0x23
(0034)                       037  || .EQU NES_CONTROLLER = 0x25
(0035)                       038  || .EQU RAND_NUM = 0x26
(0036)                            || 
(0037)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0038)                            || ;; DEFINTION OF DIGIT LUT AND DATA IN SCRATCH
(0039)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0040)                            || ;; The Following DSEG block defines a LUT for data that helps draw digits and the data used to draw the 
(0041)                            || ;; digits themselves. The digits are 3x5 and thus each digit requires 5 places in scratch to represent. 
(0042)                            || ;; The DRAW_DIG function will utilize this data section.
(0043)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0044)                            || .DSEG 
(0045)                       000  || .ORG 0x00 										; The DB starts at the first location in scratch
(0046)  DS-0x000             03C  || 		      .DB 0x07, 0x05, 0x07, 0x04, 0x04  ; The data corresponding to a 9
            syntax error
            syntax error
            syntax error
            syntax error
            syntax error
            syntax error
            syntax error
            syntax error
            syntax error
            syntax error
            syntax error

(0047)                            || 
(0048)                            || 
(0049)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0050)                            || ;; REGISTER DEFINTION AND PRIMARY LOGIC LOOP
(0051)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0052)                            || ;; The Following block initializes all working registers, draws the constant elements on the VGA display, 
(0053)                            || ;; and falls into an infinite loop of updating user input.
(0054)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0055)                            || .CSEG
(0056)                       289  || .ORG 0x121                                     ;
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x3600A  0x00A  ||              MOV     r0,0x0A     ; write dseg data to reg
-STUP-  CS-0x001  0x3A000  0x000  ||              LD      r0,0x00     ; place reg data in mem 
-STUP-  CS-0x002  0x3600F  0x00F  ||              MOV     r0,0x0F     ; write dseg data to reg
-STUP-  CS-0x003  0x3A001  0x001  ||              LD      r0,0x01     ; place reg data in mem 
-STUP-  CS-0x004  0x36014  0x014  ||              MOV     r0,0x14     ; write dseg data to reg
-STUP-  CS-0x005  0x3A002  0x002  ||              LD      r0,0x02     ; place reg data in mem 
-STUP-  CS-0x006  0x36019  0x019  ||              MOV     r0,0x19     ; write dseg data to reg
-STUP-  CS-0x007  0x3A003  0x003  ||              LD      r0,0x03     ; place reg data in mem 
-STUP-  CS-0x008  0x3601E  0x01E  ||              MOV     r0,0x1E     ; write dseg data to reg
-STUP-  CS-0x009  0x3A004  0x004  ||              LD      r0,0x04     ; place reg data in mem 
-STUP-  CS-0x00A  0x36023  0x023  ||              MOV     r0,0x23     ; write dseg data to reg
-STUP-  CS-0x00B  0x3A005  0x005  ||              LD      r0,0x05     ; place reg data in mem 
-STUP-  CS-0x00C  0x36028  0x028  ||              MOV     r0,0x28     ; write dseg data to reg
-STUP-  CS-0x00D  0x3A006  0x006  ||              LD      r0,0x06     ; place reg data in mem 
-STUP-  CS-0x00E  0x3602D  0x02D  ||              MOV     r0,0x2D     ; write dseg data to reg
-STUP-  CS-0x00F  0x3A007  0x007  ||              LD      r0,0x07     ; place reg data in mem 
-STUP-  CS-0x010  0x36032  0x032  ||              MOV     r0,0x32     ; write dseg data to reg
-STUP-  CS-0x011  0x3A008  0x008  ||              LD      r0,0x08     ; place reg data in mem 
-STUP-  CS-0x012  0x36037  0x037  ||              MOV     r0,0x37     ; write dseg data to reg
-STUP-  CS-0x013  0x3A009  0x009  ||              LD      r0,0x09     ; place reg data in mem 
-STUP-  CS-0x014  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x015  0x3A00A  0x00A  ||              LD      r0,0x0A     ; place reg data in mem 
-STUP-  CS-0x016  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x017  0x3A00B  0x00B  ||              LD      r0,0x0B     ; place reg data in mem 
-STUP-  CS-0x018  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x019  0x3A00C  0x00C  ||              LD      r0,0x0C     ; place reg data in mem 
-STUP-  CS-0x01A  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x01B  0x3A00D  0x00D  ||              LD      r0,0x0D     ; place reg data in mem 
-STUP-  CS-0x01C  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x01D  0x3A00E  0x00E  ||              LD      r0,0x0E     ; place reg data in mem 
-STUP-  CS-0x01E  0x36003  0x003  ||              MOV     r0,0x03     ; write dseg data to reg
-STUP-  CS-0x01F  0x3A00F  0x00F  ||              LD      r0,0x0F     ; place reg data in mem 
-STUP-  CS-0x020  0x36002  0x002  ||              MOV     r0,0x02     ; write dseg data to reg
-STUP-  CS-0x021  0x3A010  0x010  ||              LD      r0,0x10     ; place reg data in mem 
-STUP-  CS-0x022  0x36002  0x002  ||              MOV     r0,0x02     ; write dseg data to reg
-STUP-  CS-0x023  0x3A011  0x011  ||              LD      r0,0x11     ; place reg data in mem 
-STUP-  CS-0x024  0x36002  0x002  ||              MOV     r0,0x02     ; write dseg data to reg
-STUP-  CS-0x025  0x3A012  0x012  ||              LD      r0,0x12     ; place reg data in mem 
-STUP-  CS-0x026  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x027  0x3A013  0x013  ||              LD      r0,0x13     ; place reg data in mem 
-STUP-  CS-0x028  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x029  0x3A014  0x014  ||              LD      r0,0x14     ; place reg data in mem 
-STUP-  CS-0x02A  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x02B  0x3A015  0x015  ||              LD      r0,0x15     ; place reg data in mem 
-STUP-  CS-0x02C  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x02D  0x3A016  0x016  ||              LD      r0,0x16     ; place reg data in mem 
-STUP-  CS-0x02E  0x36001  0x001  ||              MOV     r0,0x01     ; write dseg data to reg
-STUP-  CS-0x02F  0x3A017  0x017  ||              LD      r0,0x17     ; place reg data in mem 
-STUP-  CS-0x030  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x031  0x3A018  0x018  ||              LD      r0,0x18     ; place reg data in mem 
-STUP-  CS-0x032  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x033  0x3A019  0x019  ||              LD      r0,0x19     ; place reg data in mem 
-STUP-  CS-0x034  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x035  0x3A01A  0x01A  ||              LD      r0,0x1A     ; place reg data in mem 
-STUP-  CS-0x036  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x037  0x3A01B  0x01B  ||              LD      r0,0x1B     ; place reg data in mem 
-STUP-  CS-0x038  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x039  0x3A01C  0x01C  ||              LD      r0,0x1C     ; place reg data in mem 
-STUP-  CS-0x03A  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x03B  0x3A01D  0x01D  ||              LD      r0,0x1D     ; place reg data in mem 
-STUP-  CS-0x03C  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x03D  0x3A01E  0x01E  ||              LD      r0,0x1E     ; place reg data in mem 
-STUP-  CS-0x03E  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x03F  0x3A01F  0x01F  ||              LD      r0,0x1F     ; place reg data in mem 
-STUP-  CS-0x040  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x041  0x3A020  0x020  ||              LD      r0,0x20     ; place reg data in mem 
-STUP-  CS-0x042  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x043  0x3A021  0x021  ||              LD      r0,0x21     ; place reg data in mem 
-STUP-  CS-0x044  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x045  0x3A022  0x022  ||              LD      r0,0x22     ; place reg data in mem 
-STUP-  CS-0x046  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x047  0x3A023  0x023  ||              LD      r0,0x23     ; place reg data in mem 
-STUP-  CS-0x048  0x36001  0x001  ||              MOV     r0,0x01     ; write dseg data to reg
-STUP-  CS-0x049  0x3A024  0x024  ||              LD      r0,0x24     ; place reg data in mem 
-STUP-  CS-0x04A  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x04B  0x3A025  0x025  ||              LD      r0,0x25     ; place reg data in mem 
-STUP-  CS-0x04C  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x04D  0x3A026  0x026  ||              LD      r0,0x26     ; place reg data in mem 
-STUP-  CS-0x04E  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x04F  0x3A027  0x027  ||              LD      r0,0x27     ; place reg data in mem 
-STUP-  CS-0x050  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x051  0x3A028  0x028  ||              LD      r0,0x28     ; place reg data in mem 
-STUP-  CS-0x052  0x36001  0x001  ||              MOV     r0,0x01     ; write dseg data to reg
-STUP-  CS-0x053  0x3A029  0x029  ||              LD      r0,0x29     ; place reg data in mem 
-STUP-  CS-0x054  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x055  0x3A02A  0x02A  ||              LD      r0,0x2A     ; place reg data in mem 
-STUP-  CS-0x056  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x057  0x3A02B  0x02B  ||              LD      r0,0x2B     ; place reg data in mem 
-STUP-  CS-0x058  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x059  0x3A02C  0x02C  ||              LD      r0,0x2C     ; place reg data in mem 
-STUP-  CS-0x05A  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x05B  0x3A02D  0x02D  ||              LD      r0,0x2D     ; place reg data in mem 
-STUP-  CS-0x05C  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x05D  0x3A02E  0x02E  ||              LD      r0,0x2E     ; place reg data in mem 
-STUP-  CS-0x05E  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x05F  0x3A02F  0x02F  ||              LD      r0,0x2F     ; place reg data in mem 
-STUP-  CS-0x060  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x061  0x3A030  0x030  ||              LD      r0,0x30     ; place reg data in mem 
-STUP-  CS-0x062  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x063  0x3A031  0x031  ||              LD      r0,0x31     ; place reg data in mem 
-STUP-  CS-0x064  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x065  0x3A032  0x032  ||              LD      r0,0x32     ; place reg data in mem 
-STUP-  CS-0x066  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x067  0x3A033  0x033  ||              LD      r0,0x33     ; place reg data in mem 
-STUP-  CS-0x068  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x069  0x3A034  0x034  ||              LD      r0,0x34     ; place reg data in mem 
-STUP-  CS-0x06A  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x06B  0x3A035  0x035  ||              LD      r0,0x35     ; place reg data in mem 
-STUP-  CS-0x06C  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x06D  0x3A036  0x036  ||              LD      r0,0x36     ; place reg data in mem 
-STUP-  CS-0x06E  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x06F  0x3A037  0x037  ||              LD      r0,0x37     ; place reg data in mem 
-STUP-  CS-0x070  0x36005  0x005  ||              MOV     r0,0x05     ; write dseg data to reg
-STUP-  CS-0x071  0x3A038  0x038  ||              LD      r0,0x38     ; place reg data in mem 
-STUP-  CS-0x072  0x36007  0x007  ||              MOV     r0,0x07     ; write dseg data to reg
-STUP-  CS-0x073  0x3A039  0x039  ||              LD      r0,0x39     ; place reg data in mem 
-STUP-  CS-0x074  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x075  0x3A03A  0x03A  ||              LD      r0,0x3A     ; place reg data in mem 
-STUP-  CS-0x076  0x36004  0x004  ||              MOV     r0,0x04     ; write dseg data to reg
-STUP-  CS-0x077  0x3A03B  0x03B  ||              LD      r0,0x3B     ; place reg data in mem 
-STUP-  CS-0x078  0x08908  0x100  ||              BRN     0x121        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0057)  CS-0x121  0x3600A  0x121  || SETUP:		   MOV R0,  0x0A                   ; X offset
(0058)  CS-0x122  0x3610A         || 			   MOV R1,  0x0A                   ; Y offset
(0059)  CS-0x123  0x36200         || 			   MOV R2,  0x00                   ; COLOR
(0060)  CS-0x124  0x36300         || 			   MOV R3,  0x00                   ; GENERAL_TEMP_DATA
(0061)  CS-0x125  0x36400         || 			   MOV R4,  0x00                   ; ROM_ADDR_DIG
(0062)  CS-0x126  0x36500         || 			   MOV R5,  0x00                   ; 0
(0063)  CS-0x127  0x36601         || 			   MOV R6,  0x01                   ; 1
(0064)  CS-0x128  0x36700         || 			   MOV R7,  0x00                   ; TEMP_X
(0065)  CS-0x129  0x36800         || 			   MOV R8,  0x00                   ; TEMP_Y
(0066)  CS-0x12A  0x36900         || 			   MOV R9,  0x00                   ; TEMP_TIME
(0067)  CS-0x12B  0x36A00         || 			   MOV R10, 0x00                   ; VERT = 1, HORIZ = 0
(0068)  CS-0x12C  0x36B00         || 			   MOV R11, 0x00                   ; USER_INPUT
(0069)  CS-0x12D  0x36C00         ||                MOV R12, 0x00                   ; TEMP_USER_INPUT
(0070)  CS-0x12E  0x36D00         || 			   MOV R13, 0x00                   ; Pause
(0071)  CS-0x12F  0x36E00         || 			   MOV R14, 0x00                   ; PREV_INPUT
(0072)  CS-0x130  0x36D03         || 			   MOV R13, 0x03                   ; 3
(0073)  CS-0x131  0x36E05         || 			   MOV R14, 0x05                   ; 5
(0074)  CS-0x132  0x36F00         || 			   MOV R15, 0x00                   ; TEMP_DIG_DATA
(0075)  CS-0x133  0x37000         || 			   MOV R16, 0x00                   ; TEMP_COLOR
(0076)  CS-0x134  0x371FF         || 			   MOV R17, 0xFF                   ; PREV_TIME_SECS_0
(0077)  CS-0x135  0x372FF         || 			   MOV R18, 0xFF                   ; PREV_TIME_SECS_10
(0078)  CS-0x136  0x373FF         || 			   MOV R19, 0xFF                   ; PREV_TIME_MINS_0
(0079)  CS-0x137  0x374FF         || 			   MOV R20, 0xFF 	               ; PREV_TIME_MINS_10
(0080)  CS-0x138  0x1A000         || 			   SEI							   ; Enable interrupts
(0081)  CS-0x139  0x34589         ||                OUT R5, TIMER_CON               ; Enable timer by setting its pause input to 0 
(0082)  CS-0x13A  0x089E9         || 			   CALL DRAW_CONST                 ; Draw constant elements on the VGA screen
(0083)  CS-0x13B  0x090E1  0x13B  || USR_LOOP:      CALL USER_IN_UPDT               ; Read user input and update VGA and UART output accordingly
(0084)  CS-0x13C  0x089D8         || 			   BRN USR_LOOP                    ; Contineuly poll for changes in user input
(0085)                            || 
(0086)                            || 
(0087)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0088)                            || ;; DRAW CONSTANT ELEMENTS ON VGA DISPLAY
(0089)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0090)                            || ;; The following block utilizes the LINE_DRAW function to draw the static elements of the display when the
(0091)                            || ;; program first starts up. This is done by setting pertanent registers and then calling the LINE_DRAW
(0092)                            || ;; function. All of these calls are performed the same way so only one line draw will be commented in detail.
(0093)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0094)  CS-0x13D  0x362FF  0x13D  || DRAW_CONST:	   MOV R2, 0xFF						; Set the color of the line (White in this case)				
(0095)  CS-0x13E  0x36003         || 			   MOV R0, 0x03						; Set the X offset for the line
(0096)  CS-0x13F  0x36101         || 		       MOV R1, 0x01						; Set the Y offset for the line
(0097)  CS-0x140  0x36321         || 			   MOV R3, 0x21						; Set the length of the line (in pixels)
(0098)  CS-0x141  0x36A00         ||                MOV R10, 0x00				    ; Set whether the line is horizontal (0) or vertical (1)
(0099)  CS-0x142  0x08F71         || 			   CALL LINE_DRAW					; Call the line_draw function, drawing the line described 
(0100)  CS-0x143  0x36102         || 		       MOV R1, 0x02		
(0101)  CS-0x144  0x36321         || 			   MOV R3, 0x21
(0102)  CS-0x145  0x08F71         || 			   CALL LINE_DRAW
(0103)  CS-0x146  0x36102         || 		       MOV R1, 0x02
(0104)  CS-0x147  0x3630E         || 			   MOV R3, 0x0E
(0105)  CS-0x148  0x36A01         ||                MOV R10, 0x01
(0106)  CS-0x149  0x08F71         || 			   CALL LINE_DRAW
(0107)  CS-0x14A  0x36110         ||                MOV R1, 0x10
(0108)  CS-0x14B  0x36321         || 			   MOV R3, 0x21
(0109)  CS-0x14C  0x36A00         ||                MOV R10, 0x00
(0110)  CS-0x14D  0x08F71         ||                CALL LINE_DRAW
(0111)  CS-0x14E  0x36102         ||                MOV R1, 0x02
(0112)  CS-0x14F  0x36024         || 			   MOV R0, 0x24
(0113)  CS-0x150  0x3630E         || 			   MOV R3, 0x0E
(0114)  CS-0x151  0x36A01         ||                MOV R10, 0x01
(0115)  CS-0x152  0x08F71         || 			   CALL LINE_DRAW
(0116)  CS-0x153  0x3600F         || 			   MOV R0, 0x0F
(0117)  CS-0x154  0x36103         || 			   MOV R1, 0x03
(0118)  CS-0x155  0x36308         || 			   MOV R3, 0x08
(0119)  CS-0x156  0x36A00         ||                MOV R10, 0x00
(0120)  CS-0x157  0x08F71         || 			   CALL LINE_DRAW
(0121)  CS-0x158  0x36105         || 			   MOV R1, 0x05
(0122)  CS-0x159  0x36308         || 			   MOV R3, 0x08
(0123)  CS-0x15A  0x08F71         ||                CALL LINE_DRAW
(0124)  CS-0x15B  0x36107         || 			   MOV R1, 0x07
(0125)  CS-0x15C  0x36308         || 			   MOV R3, 0x08
(0126)  CS-0x15D  0x08F71         || 			   CALL LINE_DRAW
(0127)  CS-0x15E  0x36109         || 			    MOV R1, 0x09
(0128)  CS-0x15F  0x36308         || 			   MOV R3, 0x08
(0129)  CS-0x160  0x08F71         || 			   CALL LINE_DRAW
(0130)  CS-0x161  0x3610D         || 			   MOV R1, 0x0D
(0131)  CS-0x162  0x36308         || 			   MOV R3, 0x08
(0132)  CS-0x163  0x08F71         || 			   CALL LINE_DRAW
(0133)  CS-0x164  0x3610F         || 			   MOV R1, 0x0F
(0134)  CS-0x165  0x36308         || 			   MOV R3, 0x08
(0135)  CS-0x166  0x08F71         || 			   CALL LINE_DRAW
(0136)  CS-0x167  0x3600F         ||                MOV R0, 0x0F
(0137)  CS-0x168  0x3610A         || 			   MOV R1, 0x0A
(0138)  CS-0x169  0x36303         || 			   MOV R3, 0x03
(0139)  CS-0x16A  0x36A01         || 			   MOV R10, 0x01
(0140)  CS-0x16B  0x08F71         || 			   CALL LINE_DRAW
(0141)  CS-0x16C  0x36017         ||                MOV R0, 0x17
(0142)  CS-0x16D  0x36303         || 			   MOV R3, 0x03
(0143)  CS-0x16E  0x08F71         || 			   CALL LINE_DRAW
(0144)  CS-0x16F  0x36019         ||                MOV R0, 0x19
(0145)  CS-0x170  0x36303         || 			   MOV R3, 0x03
(0146)  CS-0x171  0x08F71         || 			   CALL LINE_DRAW
(0147)  CS-0x172  0x3601D         ||                MOV R0, 0x1D
(0148)  CS-0x173  0x36303         || 			   MOV R3, 0x03
(0149)  CS-0x174  0x08F71         || 			   CALL LINE_DRAW
(0150)  CS-0x175  0x36021         ||                MOV R0, 0x21
(0151)  CS-0x176  0x36303         || 			   MOV R3, 0x03
(0152)  CS-0x177  0x08F71         || 			   CALL LINE_DRAW
(0153)  CS-0x178  0x36019         ||                MOV R0, 0x19
(0154)  CS-0x179  0x36109         || 			   MOV R1, 0x09
(0155)  CS-0x17A  0x36308         || 			   MOV R3, 0x08
(0156)  CS-0x17B  0x36A00         || 			   MOV R10, 0x00
(0157)  CS-0x17C  0x08F71         || 			   CALL LINE_DRAW
(0158)  CS-0x17D  0x3610D         || 		       MOV R1, 0x0D
(0159)  CS-0x17E  0x36308         || 			   MOV R3, 0x08
(0160)  CS-0x17F  0x08F71         || 			   CALL LINE_DRAW
(0161)  CS-0x180  0x36008         || 			   MOV R0, 0x08
(0162)  CS-0x181  0x36106         || 			   MOV R1, 0x06
(0163)  CS-0x182  0x36302         || 			   MOV R3, 0x02
(0164)  CS-0x183  0x36A01         || 			   MOV R10, 0x01
(0165)  CS-0x184  0x08F71         || 			   CALL LINE_DRAW
(0166)  CS-0x185  0x3600B         || 			   MOV R0, 0x0B
(0167)  CS-0x186  0x36302         || 			   MOV R3, 0x02
(0168)  CS-0x187  0x08F71         || 			   CALL LINE_DRAW
(0169)  CS-0x188  0x3610B         || 			   MOV R1, 0x0B
(0170)  CS-0x189  0x36302         || 			   MOV R3, 0x02
(0171)  CS-0x18A  0x08F71         || 			   CALL LINE_DRAW
(0172)  CS-0x18B  0x36008         || 			   MOV R0, 0x08
(0173)  CS-0x18C  0x36302         || 			   MOV R3, 0x02
(0174)  CS-0x18D  0x08F71         || 			   CALL LINE_DRAW
(0175)  CS-0x18E  0x36006         || 			   MOV R0, 0x06
(0176)  CS-0x18F  0x36108         || 			   MOV R1, 0x08
(0177)  CS-0x190  0x36303         || 			   MOV R3, 0x03
(0178)  CS-0x191  0x08F71         || 			   CALL LINE_DRAW
(0179)  CS-0x192  0x3600D         || 			   MOV R0, 0x0D
(0180)  CS-0x193  0x36303         || 			   MOV R3, 0x03
(0181)  CS-0x194  0x08F71         || 			   CALL LINE_DRAW
(0182)  CS-0x195  0x36007         || 			   MOV R0, 0x07
(0183)  CS-0x196  0x36301         || 			   MOV R3, 0x01
(0184)  CS-0x197  0x36A00         || 			   MOV R10, 0x00
(0185)  CS-0x198  0x08F71         || 			   CALL LINE_DRAW
(0186)  CS-0x199  0x3600B         || 			   MOV R0, 0x0B
(0187)  CS-0x19A  0x36301         || 			   MOV R3, 0x01
(0188)  CS-0x19B  0x08F71         || 			   CALL LINE_DRAW
(0189)  CS-0x19C  0x3610B         || 			   MOV R1, 0x0B
(0190)  CS-0x19D  0x36301         || 			   MOV R3, 0x01
(0191)  CS-0x19E  0x08F71         || 			   CALL LINE_DRAW
(0192)  CS-0x19F  0x36007         || 			   MOV R0, 0x07
(0193)  CS-0x1A0  0x36301         || 			   MOV R3, 0x01
(0194)  CS-0x1A1  0x08F71         || 			   CALL LINE_DRAW
(0195)  CS-0x1A2  0x36009         || 			   MOV R0, 0x09
(0196)  CS-0x1A3  0x36106         || 			   MOV R1, 0x06
(0197)  CS-0x1A4  0x36302         || 			   MOV R3, 0x02
(0198)  CS-0x1A5  0x08F71         || 			   CALL LINE_DRAW
(0199)  CS-0x1A6  0x3610D         || 			   MOV R1, 0x0D
(0200)  CS-0x1A7  0x36302         || 			   MOV R3, 0x02
(0201)  CS-0x1A8  0x08F71         || 			   CALL LINE_DRAW
(0202)  CS-0x1A9  0x36009         || 	           MOV R0, 0x09
(0203)  CS-0x1AA  0x36109         || 			   MOV R1, 0x09
(0204)  CS-0x1AB  0x36301         || 			   MOV R3, 0x01
(0205)  CS-0x1AC  0x08F71         || 			   CALL LINE_DRAW
(0206)  CS-0x1AD  0x3610A         || 			   MOV R1, 0x0A
(0207)  CS-0x1AE  0x36301         || 			   MOV R3, 0x01
(0208)  CS-0x1AF  0x08F71         || 			   CALL LINE_DRAW
(0209)  CS-0x1B0  0x36014         ||                MOV R0, 0x14
(0210)  CS-0x1B1  0x36117         || 			   MOV R1, 0x17
(0211)  CS-0x1B2  0x36203         || 			   MOV R2, 0x03
(0212)  CS-0x1B3  0x34286         || 			   OUT R2, VGA_COLOR
(0213)  CS-0x1B4  0x34084         || 			   OUT R0, VGA_COLUMN
(0214)  CS-0x1B5  0x34185         || 			   OUT R1, VGA_ROW
(0215)  CS-0x1B6  0x090C9         || 			   CALL UPDATE_SCREEN
(0216)  CS-0x1B7  0x36014         || 			   MOV R0, 0x14
(0217)  CS-0x1B8  0x36115         || 			   MOV R1, 0x15
(0218)  CS-0x1B9  0x34084         || 			   OUT R0, VGA_COLUMN
(0219)  CS-0x1BA  0x34185         || 			   OUT R1, VGA_ROW
(0220)  CS-0x1BB  0x090C9         || 			   CALL UPDATE_SCREEN
(0221)  CS-0x1BC  0x18002         ||                RET				                ; Return after completion of drawing static objects 			
(0222)                            || 
(0223)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0224)                            || ;; INTERRUPT DRIVEN DRAW TIMER
(0225)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0226)                            || ;; The following block utilizes the TIMER input in order to create and update a timer on the VGA display.
(0227)                            || ;; This is interrupt driven when the time changes and utilizes the DRAW_DIG function in order to draw the
(0228)                            || ;; digits on the display.
(0229)                            || ;; 
(0230)                            || ;; The SECONDS and MINUTES are split into two eight bit values. Both contain BCD representations of tens of 
(0231)                            || ;; seconds/minutes in the MSBs and seconds/minutes in the LSB.
(0232)                            || ;;
(0233)                            || ;; E.G. SECONDS = 0101 0001 (This will corresond to 51 seconds on the display).
(0234)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0235)  CS-0x1BD  0x32922  0x1BD  || ISR_DRAW_TM:   IN R9, SECOND_ID                ; Read in the current seconds (0000 0000 - 0110 0000) 
(0236)  CS-0x1BE  0x2090F         || 			   AND R9,  0x0F                    ; Mask the tens of seconds
(0237)  CS-0x1BF  0x04988         || 		       CMP R9, R17                      ; Is the seconds the same as the previous seconds?
(0238)  CS-0x1C0  0x05149         || 		       MOV R17, R9                      ; Store previous seconds for next call
(0239)  CS-0x1C1  0x08E3A         || 			   BREQ DRAW_10_SEC                 ; If they are the same don't redraw this digit
(0240)  CS-0x1C2  0x0434A         ||                LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
(0241)  CS-0x1C3  0x33026  0x1C3  || RND_SEC_0: 	   IN R16, RAND_NUM                 ; Read 'random' number to the color register
(0242)  CS-0x1C4  0x3601A         || 			   MOV R0, 0x1A                     ; Set X offset
(0243)  CS-0x1C5  0x36114         || 			   MOV R1, 0x14					    ; Set Y offset
(0244)  CS-0x1C6  0x08FF9         || 			   CALL DRAW_DIG                    ; Draw the digit
(0245)  CS-0x1C7  0x32922  0x1C7  || DRAW_10_SEC:   IN R9, SECOND_ID					; Read in the current tens of seconds (0000 0000 - 0110 0000)
(0246)  CS-0x1C8  0x10901         || 			   LSR R9                           ; Shift tens of seconds to the LSB of R9
(0247)  CS-0x1C9  0x10901         || 		       LSR R9
(0248)  CS-0x1CA  0x10901         || 			   LSR R9
(0249)  CS-0x1CB  0x10901         || 			   LSR R9
(0250)  CS-0x1CC  0x2090F         || 			   AND R9, 0x0F						; Mask top 4 bits of R9
(0251)  CS-0x1CD  0x04990         || 			   CMP R9, R18					    ; Is the tens of seconds the same as the previous tens of seconds?
(0252)  CS-0x1CE  0x05249         || 			   MOV R18, R9                      ; Store previous tens of seconds for next call
(0253)  CS-0x1CF  0x08EAA         || 			   BREQ DRAW_0_MIN                  ; If they are the same don't redraw this digit
(0254)  CS-0x1D0  0x0434A         || 			   LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
(0255)  CS-0x1D1  0x33026         || 			   IN R16, RAND_NUM                 ; Read 'random' number to the color register
(0256)  CS-0x1D2  0x36016         || 			   MOV R0, 0x16                     ; Set X offset
(0257)  CS-0x1D3  0x36114         || 			   MOV R1, 0x14					    ; Set Y offset
(0258)  CS-0x1D4  0x08FF9         || 			   CALL DRAW_DIG                    ; Draw the digit
(0259)  CS-0x1D5  0x32923  0x1D5  || DRAW_0_MIN:	   IN R9, MINUTE_ID                 ; Read in the current minutes time (0000 0000 - 0110 0000) 
(0260)  CS-0x1D6  0x2090F         || 			   AND R9, 0x0F                     ; Mask the tens of minutes
(0261)  CS-0x1D7  0x04998         || 			   CMP R9, R19                      ; Is the minutes the same as the previous minutes?
(0262)  CS-0x1D8  0x05349         || 		       MOV R19, R9                      ; Store previous minutes for next call
(0263)  CS-0x1D9  0x08EFA         || 			   BREQ DRAW_10_MIN                 ; If they are the same don't redraw this digit
(0264)  CS-0x1DA  0x0434A         || 			   LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
(0265)  CS-0x1DB  0x33026         || 			   IN R16, RAND_NUM                 ; Read 'random' number to the color register
(0266)  CS-0x1DC  0x36010         || 			   MOV R0, 0x10                     ; Set X offset
(0267)  CS-0x1DD  0x36114         || 			   MOV R1, 0x14					    ; Set Y offset
(0268)  CS-0x1DE  0x08FF9         || 			   CALL DRAW_DIG                    ; Draw the digit
(0269)  CS-0x1DF  0x32923  0x1DF  || DRAW_10_MIN:   IN R9, MINUTE_ID			        ; Read in the current tens of minutes (0000 0000 - 0110 0000)
(0270)  CS-0x1E0  0x10901         || 			   LSR R9                           ; Shift tens of minutes to the LSB of R9
(0271)  CS-0x1E1  0x10901         || 		       LSR R9
(0272)  CS-0x1E2  0x10901         || 			   LSR R9
(0273)  CS-0x1E3  0x10901         || 			   LSR R9
(0274)  CS-0x1E4  0x2090F         || 			   AND R9, 0x0F					    ; Mask top 4 bits of R9
(0275)  CS-0x1E5  0x049A0         || 			   CMP R9, R20					    ; Is the tens of minutes the same as the previous tens of minutes?
(0276)  CS-0x1E6  0x05449         || 			   MOV R20, R9                      ; Store previous tens of minutes for next call
(0277)  CS-0x1E7  0x08F6A         || 			   BREQ SKIP_10_MIN                 ; If they are the same don't redraw this digit
(0278)  CS-0x1E8  0x0434A         || 			   LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
(0279)  CS-0x1E9  0x33026         || 			   IN R16, RAND_NUM                 ; Read 'random' number to the color register
(0280)  CS-0x1EA  0x3600C         || 			   MOV R0, 0x0C                     ; Set X offset
(0281)  CS-0x1EB  0x36114         || 			   MOV R1, 0x14					    ; Set Y offset
(0282)  CS-0x1EC  0x08FF9         || 			   CALL DRAW_DIG                    ; Draw the digit
(0283)  CS-0x1ED  0x1A003  0x1ED  || SKIP_10_MIN:   RETIE							; Return with interrupts enabled
(0284)                            || 
(0285)                            || 
(0286)                            || 
(0287)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0288)                            || ;; DRAW LINE ON VGA SCREEN
(0289)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0290)                            || ;; The following block utilizes the VGA_STATIC module to draw either a vertical or horizontal line of a 
(0291)                            || ;; given length on the VGA display.  
(0292)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0293)  CS-0x1EE  0x34286  0x1EE  || LINE_DRAW:	   OUT R2, VGA_COLOR                ; Set the color of the VGA display
(0294)  CS-0x1EF  0x04809         || 			   MOV R8, R1					    ; Move the X offset to a temp register
(0295)  CS-0x1F0  0x04701         || 			   MOV R7, R0					    ; Move the Y offset to a temp register
(0296)  CS-0x1F1  0x34885         || 			   OUT R8, VGA_ROW                  ; Set the ROW of the VGA Module
(0297)  CS-0x1F2  0x34784         || 	           OUT R7, VGA_COLUMN		        ; Set the COLUMN of the VGA Module
(0298)  CS-0x1F3  0x090C9         || 			   CALL UPDATE_SCREEN               ; Draw screen
(0299)  CS-0x1F4  0x30A00  0x1F4  || LINE_LOOP:     CMP R10, 0x00                    ; Compare R10 with 0
(0300)  CS-0x1F5  0x08FC2         || 			   BREQ HORIZ_LINE					; If R10 is 0 then draw a horizontal line
(0301)  CS-0x1F6  0x28801         || 			   ADD R8, 0x01					    ; Add one to Y to create a vertical line
(0302)  CS-0x1F7  0x08FC8         || 			   BRN VERT_LINE				    ; If R10 isn't 0 draw a vertical line
(0303)  CS-0x1F8  0x28701  0x1F8  || HORIZ_LINE:    ADD R7, 0x01                     ; Add one to X to create a horizontal line
(0304)  CS-0x1F9  0x34784  0x1F9  || VERT_LINE:     OUT R7, VGA_COLUMN		        ; Set the COLUMN of the VGA Module  
(0305)  CS-0x1FA  0x34885         || 	           OUT R8, VGA_ROW                  ; Set the ROW of the VGA Module
(0306)  CS-0x1FB  0x090C9         || 			   CALL UPDATE_SCREEN               ; Draw screen
(0307)  CS-0x1FC  0x2C301         || 			   SUB R3, 0x01                     ; Subtract one from length
(0308)  CS-0x1FD  0x08FA3         || 			   BRNE LINE_LOOP					; If the whole line isn't drawn loop
(0309)  CS-0x1FE  0x18002         || 			   RET								; Return when line is drawn
(0310)                            || 
(0311)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0312)                            || ;; DRAW DIGIT ON VGA SCREEN
(0313)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0314)                            || ;; The following block utilizes the VGA_STATIC module to a numeric digit on the VGA screen.
(0315)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0316)  CS-0x1FF  0x04F1A  0x1FF  || DRAW_DIG:      LD R15, (R3)                     ; Load scratch memory location from LUT in the scratch
(0317)  CS-0x200  0x36E05         || 			   MOV R14, 0x05					; 0x05 is the height of a digit
(0318)  CS-0x201  0x04801         || 			   MOV R8, R0						; Copy X to a temp register
(0319)  CS-0x202  0x04709         || 			   MOV R7, R1  				        ; Copy Y to a temp register
(0320)  CS-0x203  0x04F1A  0x203  || DIG_LOOP:      LD R15, (R3)	   					; Load next line of Digit
(0321)  CS-0x204  0x36D03         || 			   MOV R13, 0x03                    ; Width of a digit is 3
(0322)  CS-0x205  0x10F01  0x205  || DIG_LINE:      LSR R15                          ; Shift LSB out of digit line data
(0323)  CS-0x206  0x0B048         || 			   BRCS ON_PIX						; If a one is shifted out turn on the current pixel
(0324)  CS-0x207  0x36200         || 			   MOV R2, 0x00						; Otherwise turn the pixel off
(0325)  CS-0x208  0x09058         || 			   BRN OFF_PIX					    ; Skip ON_PIX
(0326)  CS-0x209  0x04281  0x209  || ON_PIX:		   MOV R2, R16						; Copy random color into the color register
(0327)  CS-0x20A  0x34281         || 			   OUT R2, SSEG					    ; Output the random number for the color
(0328)  CS-0x20B  0x34286  0x20B  || OFF_PIX:	   OUT R2, VGA_COLOR				; Set color of VGA
(0329)  CS-0x20C  0x34785         || 			   OUT R7, VGA_ROW				    ; Set ROW of VGA
(0330)  CS-0x20D  0x34884         || 			   OUT R8, VGA_COLUMN				; Set Column of VGA
(0331)  CS-0x20E  0x090C9         || 			   CALL UPDATE_SCREEN      			; Draw screen with current outputs
(0332)  CS-0x20F  0x28801         || 			   ADD R8, 0x01						; Go to the next pixel horizontally 
(0333)  CS-0x210  0x2CD01         || 			   SUB R13, 0x01					; Subtract one from 3 
(0334)  CS-0x211  0x0902B         || 			   BRNE DIG_LINE					; DIG_LINE happends 3 times for every DIG_LOOP
(0335)  CS-0x212  0x36D03         || 			   MOV R13, 0x03					; Replenish R13 with width of digit
(0336)  CS-0x213  0x04801         || 			   MOV R8, R0						; Recopy offset of X
(0337)  CS-0x214  0x28701         || 			   ADD R7, 0x01					    ; Add one to Y
(0338)  CS-0x215  0x28301         || 			   ADD R3, 0x01						; Got to next memory location for info about next line in dig
(0339)  CS-0x216  0x2CE01         || 			   SUB R14, 0x01					; Subtract one from 5
(0340)  CS-0x217  0x0901B         || 			   BRNE DIG_LOOP					; DIG_LOOP happens 5 times for every DRAW_DIG call
(0341)  CS-0x218  0x18002         || 			   RET								; Return when done drawing digit
(0342)                            || 
(0343)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0344)                            || ;; UPDATE VGA SCREEN
(0345)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0346)                            || ;; The following block pulses the Enable on the VGA module to process current inputs to the VGA module.
(0347)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0348)  CS-0x219  0x34688  0x219  || UPDATE_SCREEN: OUT R6, VGA_EN
(0349)  CS-0x21A  0x34588         || 			   OUT R5, VGA_EN
(0350)  CS-0x21B  0x18002         || 			   RET
(0351)                            || 
(0352)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0353)                            || ;; UPDATE USER INPUT
(0354)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0355)                            || ;; The following block reads the input from the NES controller, outputs it to the TX UART module, checks for
(0356)                            || ;; resets/pauses of the timer, and drives the VGA to show user inputs. A portion of this code is essentially
(0357)                            || ;; repeat thus only the first iteration will be commented throughly.
(0358)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0359)  CS-0x21C  0x32B25  0x21C  || USER_IN_UPDT:  IN R11, NES_CONTROLLER			; Read input from the NES controller
(0360)  CS-0x21D  0x34682         || 			   OUT R6, TX_CON					; Enable TX UART module
(0361)  CS-0x21E  0x34B83         || 			   OUT R11, TX_DATA					; Output current user input over UART
(0362)  CS-0x21F  0x34582         || 			   OUT R5, TX_CON					; Disable TX UART module
(0363)  CS-0x220  0x04B70         || 			   CMP R11, R14						; Compare current input to previous input
(0364)  CS-0x221  0x0911B         || 			   BRNE DONT_BREAK					; If current input /= previous input continue
(0365)  CS-0x222  0x18002         || 			   RET								; Otherwise return
(0366)  CS-0x223  0x04E59  0x223  || DONT_BREAK:	   MOV R14, R11						; Copy input to temp register
(0367)  CS-0x224  0x30BB0         || 			   CMP R11, 0xB0					; Check if Start, Select, and B are pressed
(0368)  CS-0x225  0x0914B         || 			   BRNE NO_TIMER_RST				; If they aren't don't pause timer
(0369)  CS-0x226  0x36C02         || 		       MOV R12, 0x02					; Move number for 'reset'
(0370)  CS-0x227  0x34C89         || 			   OUT R12, TIMER_CON				; Set the timer to reset
(0371)  CS-0x228  0x34589         || 			   OUT R5, TIMER_CON				; Return timer control inputs to 0
(0372)  CS-0x229  0x30B30  0x229  || NO_TIMER_RST:  CMP R11, 0x30                    ; Check if Start and Select are pressed
(0373)  CS-0x22A  0x09193         || 			   BRNE EXIT_TIME					; If not true skip pause logic
(0374)  CS-0x22B  0x30D00         || 		       CMP R13, 0x00					; Check if we are paused or not
(0375)  CS-0x22C  0x09182         || 			   BREQ PAUSE_ON					; If we paused (R13 = 1)
(0376)  CS-0x22D  0x36D00         || 			   MOV R13, 0x00					; Set state to 'un-paused'
(0377)  CS-0x22E  0x34D89         || 			   OUT R13, TIMER_CON				; Un-pause timer
(0378)  CS-0x22F  0x09190         || 			   BRN EXIT_TIME					; Skip pause logic
(0379)  CS-0x230  0x36D01  0x230  || PAUSE_ON:	   MOV R13, 0x01					; If we aren't paused (R13 = 0), set state to paused
(0380)  CS-0x231  0x34D89         || 			   OUT R13, TIMER_CON               ; Pause the timer
(0381)  CS-0x232  0x04C59  0x232  || EXIT_TIME:     MOV R12, R11    					; Copy user input to temp register
(0382)  CS-0x233  0x20C40         || 			   AND R12, 0x40					; Mask for the bit corresponding to 'A'
(0383)  CS-0x234  0x30C00         || 			   CMP R12, 0x00					; Compare to '0'
(0384)  CS-0x235  0x091C2         || 			   BREQ OFF_A						; Branch if 'A' isn't '1'
(0385)  CS-0x236  0x362E0         || 			   MOV R2, 0xE0						; If 'A' is one set Color register to red
(0386)  CS-0x237  0x091C8         ||                BRN ON_A							; Skip Off_A
(0387)  CS-0x238  0x36200  0x238  || OFF_A:         MOV R2, 0x00						; If 'A' isn't '1' then set color to black
(0388)  CS-0x239  0x34286  0x239  || ON_A:	       OUT R2, VGA_COLOR                ; Set color on the VGA module 
(0389)  CS-0x23A  0x3601E         ||                MOV R0, 0x1E						; The following code until MOV R12, R11, sets pixels that
(0390)  CS-0x23B  0x3610A         || 			   MOV R1, 0x0A						; represent the buttons similar to the DRAW_CONST function
(0391)  CS-0x23C  0x36302         ||                MOV R3, 0x02						
(0392)  CS-0x23D  0x36A00         || 		       MOV R10, 0x00					
(0393)  CS-0x23E  0x08F71         || 			   CALL LINE_DRAW					
(0394)  CS-0x23F  0x3610B         || 			   MOV R1, 0x0B
(0395)  CS-0x240  0x36302         ||                MOV R3, 0x02
(0396)  CS-0x241  0x08F71         || 			   CALL LINE_DRAW
(0397)  CS-0x242  0x3610C         || 			   MOV R1, 0x0C
(0398)  CS-0x243  0x36302         ||                MOV R3, 0x02
(0399)  CS-0x244  0x08F71         || 			   CALL LINE_DRAW
(0400)  CS-0x245  0x04C59         || 			   MOV R12, R11    
(0401)  CS-0x246  0x20C80         || 			   AND R12, 0x80
(0402)  CS-0x247  0x30C00         || 			   CMP R12, 0x00
(0403)  CS-0x248  0x0925A         || 			   BREQ OFF_B
(0404)  CS-0x249  0x362E0         || 			   MOV R2, 0xE0
(0405)  CS-0x24A  0x09260         ||                BRN ON_B
(0406)  CS-0x24B  0x36200  0x24B  || OFF_B:         MOV R2, 0x00
(0407)  CS-0x24C  0x34286  0x24C  || ON_B:	       OUT R2, VGA_COLOR
(0408)  CS-0x24D  0x3601A         || 			   MOV R0, 0x1A
(0409)  CS-0x24E  0x3610A         || 			   MOV R1, 0x0A
(0410)  CS-0x24F  0x36302         || 			   MOV R3, 0x02
(0411)  CS-0x250  0x36A00         || 		       MOV R10, 0x00
(0412)  CS-0x251  0x08F71         || 			   CALL LINE_DRAW
(0413)  CS-0x252  0x3610B         || 			   MOV R1, 0x0B
(0414)  CS-0x253  0x36302         ||                MOV R3, 0x02
(0415)  CS-0x254  0x08F71         || 			   CALL LINE_DRAW
(0416)  CS-0x255  0x3610C         || 			   MOV R1, 0x0C
(0417)  CS-0x256  0x36302         ||                MOV R3, 0x02
(0418)  CS-0x257  0x08F71         || 			   CALL LINE_DRAW
(0419)  CS-0x258  0x04C59         || 			   MOV R12, R11    
(0420)  CS-0x259  0x20C20         || 			   AND R12, 0x20
(0421)  CS-0x25A  0x30C00         || 			   CMP R12, 0x00
(0422)  CS-0x25B  0x092F2         || 			   BREQ OFF_SEL
(0423)  CS-0x25C  0x362E0         || 			   MOV R2, 0xE0
(0424)  CS-0x25D  0x092F8         ||                BRN ON_SEL
(0425)  CS-0x25E  0x36200  0x25E  || OFF_SEL:       MOV R2, 0x00
(0426)  CS-0x25F  0x34286  0x25F  || ON_SEL:	       OUT R2, VGA_COLOR
(0427)  CS-0x260  0x36011         ||                MOV R0, 0x11
(0428)  CS-0x261  0x3610B         || 			   MOV R1, 0x0B
(0429)  CS-0x262  0x36301         || 		       MOV R3, 0x01
(0430)  CS-0x263  0x36A00         || 		       MOV R10, 0x00
(0431)  CS-0x264  0x08F71         || 			   CALL LINE_DRAW
(0432)  CS-0x265  0x04C59         || 			   MOV R12, R11    
(0433)  CS-0x266  0x20C10         || 			   AND R12, 0x10
(0434)  CS-0x267  0x30C00         || 			   CMP R12, 0x00
(0435)  CS-0x268  0x0935A         || 			   BREQ OFF_STRT
(0436)  CS-0x269  0x362E0         || 			   MOV R2, 0xE0
(0437)  CS-0x26A  0x09360         ||                BRN ON_STRT
(0438)  CS-0x26B  0x36200  0x26B  || OFF_STRT:      MOV R2, 0x00
(0439)  CS-0x26C  0x34286  0x26C  || ON_STRT:	   OUT R2, VGA_COLOR
(0440)  CS-0x26D  0x36014         || 			   MOV R0, 0x14
(0441)  CS-0x26E  0x3610B         || 			   MOV R1, 0x0B
(0442)  CS-0x26F  0x36301         || 		       MOV R3, 0x01
(0443)  CS-0x270  0x36A00         || 		       MOV R10, 0x00
(0444)  CS-0x271  0x08F71         || 			   CALL LINE_DRAW
(0445)  CS-0x272  0x04C59         || 			   MOV R12, R11    
(0446)  CS-0x273  0x20C01         || 			   AND R12, 0x01
(0447)  CS-0x274  0x30C00         || 			   CMP R12, 0x00
(0448)  CS-0x275  0x093C2         || 			   BREQ OFF_UP
(0449)  CS-0x276  0x362E0         || 			   MOV R2, 0xE0
(0450)  CS-0x277  0x093C8         ||                BRN ON_UP
(0451)  CS-0x278  0x36200  0x278  || OFF_UP:        MOV R2, 0x00
(0452)  CS-0x279  0x34286  0x279  || ON_UP:	       OUT R2, VGA_COLOR
(0453)  CS-0x27A  0x36009         || 			   MOV R0, 0x09
(0454)  CS-0x27B  0x36107         || 			   MOV R1, 0x07
(0455)  CS-0x27C  0x36301         || 			   MOV R3, 0x01
(0456)  CS-0x27D  0x36A00         ||                MOV R10, 0x00
(0457)  CS-0x27E  0x08F71         || 			   CALL LINE_DRAW
(0458)  CS-0x27F  0x36108         || 			   MOV R1, 0x08
(0459)  CS-0x280  0x36301         || 			   MOV R3, 0x01
(0460)  CS-0x281  0x08F71         || 			   CALL LINE_DRAW
(0461)  CS-0x282  0x04C59         || 			   MOV R12, R11    
(0462)  CS-0x283  0x20C04         || 			   AND R12, 0x04
(0463)  CS-0x284  0x30C00         || 			   CMP R12, 0x00
(0464)  CS-0x285  0x09442         || 			   BREQ OFF_DOWN
(0465)  CS-0x286  0x362E0         || 			   MOV R2, 0xE0
(0466)  CS-0x287  0x09448         ||                BRN ON_DOWN
(0467)  CS-0x288  0x36200  0x288  || OFF_DOWN:      MOV R2, 0x00
(0468)  CS-0x289  0x34286  0x289  || ON_DOWN:	   OUT R2, VGA_COLOR
(0469)  CS-0x28A  0x36009         || 		       MOV R0, 0x09
(0470)  CS-0x28B  0x3610B         || 			   MOV R1, 0x0B
(0471)  CS-0x28C  0x36301         || 			   MOV R3, 0x01
(0472)  CS-0x28D  0x36A00         || 		       MOV R10, 0x00
(0473)  CS-0x28E  0x08F71         || 			   CALL LINE_DRAW
(0474)  CS-0x28F  0x3610C         || 			   MOV R1, 0x0C
(0475)  CS-0x290  0x36301         || 			   MOV R3, 0x01
(0476)  CS-0x291  0x08F71         || 			   CALL LINE_DRAW
(0477)  CS-0x292  0x04C59         || 			   MOV R12, R11    
(0478)  CS-0x293  0x20C02         || 			   AND R12, 0x02
(0479)  CS-0x294  0x30C00         || 			   CMP R12, 0x00
(0480)  CS-0x295  0x094C2         || 			   BREQ OFF_LEFT
(0481)  CS-0x296  0x362E0         || 			   MOV R2, 0xE0
(0482)  CS-0x297  0x094C8         ||                BRN ON_LEFT
(0483)  CS-0x298  0x36200  0x298  || OFF_LEFT:      MOV R2, 0x00
(0484)  CS-0x299  0x34286  0x299  || ON_LEFT:	   OUT R2, VGA_COLOR
(0485)  CS-0x29A  0x36007         || 			   MOV R0, 0x07
(0486)  CS-0x29B  0x36109         || 			   MOV R1, 0x09
(0487)  CS-0x29C  0x36301         || 		       MOV R3, 0x01
(0488)  CS-0x29D  0x36A00         || 		       MOV R10, 0x00
(0489)  CS-0x29E  0x08F71         || 			   CALL LINE_DRAW
(0490)  CS-0x29F  0x3610A         || 			   MOV R1, 0x0A
(0491)  CS-0x2A0  0x36301         || 			   MOV R3, 0x01
(0492)  CS-0x2A1  0x08F71         || 			   CALL LINE_DRAW
(0493)  CS-0x2A2  0x04C59         || 			   MOV R12, R11    
(0494)  CS-0x2A3  0x20C08         || 			   AND R12, 0x08
(0495)  CS-0x2A4  0x30C00         || 			   CMP R12, 0x00
(0496)  CS-0x2A5  0x09542         || 			   BREQ OFF_RIGHT
(0497)  CS-0x2A6  0x362E0         || 			   MOV R2, 0xE0
(0498)  CS-0x2A7  0x09548         ||                BRN ON_RIGHT
(0499)  CS-0x2A8  0x36200  0x2A8  || OFF_RIGHT:     MOV R2, 0x00
(0500)  CS-0x2A9  0x34286  0x2A9  || ON_RIGHT:	   OUT R2, VGA_COLOR
(0501)  CS-0x2AA  0x3600B         || 	           MOV R0, 0x0B
(0502)  CS-0x2AB  0x36109         || 			   MOV R1, 0x09
(0503)  CS-0x2AC  0x36301         || 			   MOV R3, 0x01
(0504)  CS-0x2AD  0x36A00         || 		       MOV R10, 0x00
(0505)  CS-0x2AE  0x08F71         || 			   CALL LINE_DRAW
(0506)  CS-0x2AF  0x3610A         || 			   MOV R1, 0x0A
(0507)  CS-0x2B0  0x36301         || 			   MOV R3, 0x01
(0508)  CS-0x2B1  0x08F71         || 			   CALL LINE_DRAW
(0509)  CS-0x2B2  0x18002         || 			   RET
(0510)                            || 
(0511)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0512)                            || ;; ISR SETUP
(0513)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0514)                            || ;; The following block setups the branch to ISR_DRAW_TM for handling Interrupt events produced from the
(0515)                            || ;; interrupt handler.
(0516)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(0517)                       1023  || .ORG 0x3FF
(0518)  CS-0x3FF  0x08DE8         || BRN ISR_DRAW_TM					; ISR_DRAW_TM is the Interrupt Service Routine
(0519)                            || ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
DIG_LINE       0x205   (0322)  ||  0334 
DIG_LOOP       0x203   (0320)  ||  0340 
DONT_BREAK     0x223   (0366)  ||  0364 
DRAW_0_MIN     0x1D5   (0259)  ||  0253 
DRAW_10_MIN    0x1DF   (0269)  ||  0263 
DRAW_10_SEC    0x1C7   (0245)  ||  0239 
DRAW_CONST     0x13D   (0094)  ||  0082 
DRAW_DIG       0x1FF   (0316)  ||  0244 0258 0268 0282 
EXIT_TIME      0x232   (0381)  ||  0373 0378 
HORIZ_LINE     0x1F8   (0303)  ||  0300 
ISR_DRAW_TM    0x1BD   (0235)  ||  0518 
LINE_DRAW      0x1EE   (0293)  ||  0099 0102 0106 0110 0115 0120 0123 0126 0129 0132 
                               ||  0135 0140 0143 0146 0149 0152 0157 0160 0165 0168 
                               ||  0171 0174 0178 0181 0185 0188 0191 0194 0198 0201 
                               ||  0205 0208 0393 0396 0399 0412 0415 0418 0431 0444 
                               ||  0457 0460 0473 0476 0489 0492 0505 0508 
LINE_LOOP      0x1F4   (0299)  ||  0308 
NO_TIMER_RST   0x229   (0372)  ||  0368 
OFF_A          0x238   (0387)  ||  0384 
OFF_B          0x24B   (0406)  ||  0403 
OFF_DOWN       0x288   (0467)  ||  0464 
OFF_LEFT       0x298   (0483)  ||  0480 
OFF_PIX        0x20B   (0328)  ||  0325 
OFF_RIGHT      0x2A8   (0499)  ||  0496 
OFF_SEL        0x25E   (0425)  ||  0422 
OFF_STRT       0x26B   (0438)  ||  0435 
OFF_UP         0x278   (0451)  ||  0448 
ON_A           0x239   (0388)  ||  0386 
ON_B           0x24C   (0407)  ||  0405 
ON_DOWN        0x289   (0468)  ||  0466 
ON_LEFT        0x299   (0484)  ||  0482 
ON_PIX         0x209   (0326)  ||  0323 
ON_RIGHT       0x2A9   (0500)  ||  0498 
ON_SEL         0x25F   (0426)  ||  0424 
ON_STRT        0x26C   (0439)  ||  0437 
ON_UP          0x279   (0452)  ||  0450 
PAUSE_ON       0x230   (0379)  ||  0375 
RND_SEC_0      0x1C3   (0241)  ||  
SETUP          0x121   (0057)  ||  
SKIP_10_MIN    0x1ED   (0283)  ||  0277 
UPDATE_SCREEN  0x219   (0348)  ||  0215 0220 0298 0306 0331 
USER_IN_UPDT   0x21C   (0359)  ||  0083 
USR_LOOP       0x13B   (0083)  ||  0084 
VERT_LINE      0x1F9   (0304)  ||  0302 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
DIG_ADDR       0x087   (0020)  ||  
LEDS           0x040   (0013)  ||  
MINUTE_ID      0x023   (0033)  ||  0259 0269 
NES_ADDR       0x090   (0023)  ||  
NES_CONTROLLER 0x025   (0034)  ||  0359 
NES_ID         0x024   (0031)  ||  
RAND_NUM       0x026   (0035)  ||  0241 0255 0265 0279 
SECOND_ID      0x022   (0032)  ||  0235 0245 
SSEG           0x081   (0014)  ||  0327 
SWITCH_ID      0x020   (0030)  ||  
TIMER_CON      0x089   (0022)  ||  0081 0370 0371 0377 0380 
TX_CON         0x082   (0015)  ||  0360 0362 
TX_DATA        0x083   (0016)  ||  0361 
VGA_COLOR      0x086   (0019)  ||  0212 0293 0328 0388 0407 0426 0439 0452 0468 0484 
                               ||  0500 
VGA_COLUMN     0x084   (0017)  ||  0213 0218 0297 0304 0330 
VGA_EN         0x088   (0021)  ||  0348 0349 
VGA_ROW        0x085   (0018)  ||  0214 0219 0296 0305 0329 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
--> No ".DB" directives used
