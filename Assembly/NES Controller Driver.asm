;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Engineer: 	Ezzeddeen Gazali and Tyler Starr
;; Create Date: 03/05/2017
;; File Name: 	NES_CONTROLLER_DRIVER.asm
;; Description: The following code reads an original NES controller and drives the UART on the Basys 3 
;;				board for an emulator. Additionally, drive a VGA screen to show the cureent user inputs
;; 			    and a 'pausable'/resetable timer with randomized coloring.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFINTION OF OUTPUTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Following block defines the port ids for the OUTPUTS associated with the RAT MCU.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.EQU LEDS = 0x40
.EQU SSEG = 0x81
.EQU TX_CON = 0x82
.EQU TX_DATA = 0x83
.EQU VGA_COLUMN = 0x84
.EQU VGA_ROW = 0x85
.EQU VGA_COLOR = 0x86
.EQU DIG_ADDR = 0x87
.EQU VGA_EN = 0x88
.EQU TIMER_CON = 0x89
.EQU NES_ADDR = 0x90

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFINTION OF INPUTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Following block defines the port ids for the INPUTS associated with the RAT MCU.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.EQU SWITCH_ID = 0x20
.EQU NES_ID = 0x24
.EQU SECOND_ID = 0x22 
.EQU MINUTE_ID = 0x23
.EQU NES_CONTROLLER = 0x25
.EQU RAND_NUM = 0x26

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DEFINTION OF DIGIT LUT AND DATA IN SCRATCH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Following DSEG block defines a LUT for data that helps draw digits and the data used to draw the 
;; digits themselves. The digits are 3x5 and thus each digit requires 5 places in scratch to represent. 
;; The DRAW_DIG function will utilize this data section.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.DSEG 
.ORG 0x00 										; The DB starts at the first location in scratch
DIGIT_DATA:   .DB 0x0A, 0x0F, 0x14, 0x19, 0x1E, ; The first 10 locations in scratch contain an LUT  
			  .DB 0x23, 0x28, 0x2D, 0x32, 0x37, ; for the data locations of indivual digits
			  .DB 0x07, 0x05, 0x05, 0x05, 0x07, ; The data corresponding to a 0
			  .DB 0x03, 0x02, 0x02, 0x02, 0x07, ; The data corresponding to a 1
			  .DB 0x07, 0x04, 0x07, 0x01, 0x07, ; The data corresponding to a 2
		      .DB 0x07, 0x04, 0x07, 0x04, 0x07, ; The data corresponding to a 3
			  .DB 0x05, 0x05, 0x07, 0x04, 0x04, ; The data corresponding to a 4
			  .DB 0x07, 0x01, 0x07, 0x04, 0x07, ; The data corresponding to a 5
			  .DB 0x07, 0x01, 0x07, 0x05, 0x07, ; The data corresponding to a 6
			  .DB 0x07, 0x04, 0x04, 0x04, 0x04, ; The data corresponding to a 7
		      .DB 0x07, 0x05, 0x07, 0x05, 0x07, ; The data corresponding to a 8
		      .DB 0x07, 0x05, 0x07, 0x04, 0x04  ; The data corresponding to a 9


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REGISTER DEFINTION AND PRIMARY LOGIC LOOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Following block initializes all working registers, draws the constant elements on the VGA display, 
;; and falls into an infinite loop of updating user input.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.CSEG
.ORG 0x121                                     ;
SETUP:		   MOV R0,  0x0A                   ; X offset
			   MOV R1,  0x0A                   ; Y offset
			   MOV R2,  0x00                   ; COLOR
			   MOV R3,  0x00                   ; GENERAL_TEMP_DATA
			   MOV R4,  0x00                   ; ROM_ADDR_DIG
			   MOV R5,  0x00                   ; 0
			   MOV R6,  0x01                   ; 1
			   MOV R7,  0x00                   ; TEMP_X
			   MOV R8,  0x00                   ; TEMP_Y
			   MOV R9,  0x00                   ; TEMP_TIME
			   MOV R10, 0x00                   ; VERT = 1, HORIZ = 0
			   MOV R11, 0x00                   ; USER_INPUT
               MOV R12, 0x00                   ; TEMP_USER_INPUT
			   MOV R13, 0x00                   ; Pause
			   MOV R14, 0x00                   ; PREV_INPUT
			   MOV R13, 0x03                   ; 3
			   MOV R14, 0x05                   ; 5
			   MOV R15, 0x00                   ; TEMP_DIG_DATA
			   MOV R16, 0x00                   ; TEMP_COLOR
			   MOV R17, 0xFF                   ; PREV_TIME_SECS_0
			   MOV R18, 0xFF                   ; PREV_TIME_SECS_10
			   MOV R19, 0xFF                   ; PREV_TIME_MINS_0
			   MOV R20, 0xFF 	               ; PREV_TIME_MINS_10
			   SEI							   ; Enable interrupts
               OUT R5, TIMER_CON               ; Enable timer by setting its pause input to 0 
			   CALL DRAW_CONST                 ; Draw constant elements on the VGA screen
USR_LOOP:      CALL USER_IN_UPDT               ; Read user input and update VGA and UART output accordingly
			   BRN USR_LOOP                    ; Contineuly poll for changes in user input


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW CONSTANT ELEMENTS ON VGA DISPLAY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following block utilizes the LINE_DRAW function to draw the static elements of the display when the
;; program first starts up. This is done by setting pertanent registers and then calling the LINE_DRAW
;; function. All of these calls are performed the same way so only one line draw will be commented in detail.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_CONST:	   MOV R2, 0xFF						; Set the color of the line (White in this case)				
			   MOV R0, 0x03						; Set the X offset for the line
		       MOV R1, 0x01						; Set the Y offset for the line
			   MOV R3, 0x21						; Set the length of the line (in pixels)
               MOV R10, 0x00				    ; Set whether the line is horizontal (0) or vertical (1)
			   CALL LINE_DRAW					; Call the line_draw function, drawing the line described 
		       MOV R1, 0x02		
			   MOV R3, 0x21
			   CALL LINE_DRAW
		       MOV R1, 0x02
			   MOV R3, 0x0E
               MOV R10, 0x01
			   CALL LINE_DRAW
               MOV R1, 0x10
			   MOV R3, 0x21
               MOV R10, 0x00
               CALL LINE_DRAW
               MOV R1, 0x02
			   MOV R0, 0x24
			   MOV R3, 0x0E
               MOV R10, 0x01
			   CALL LINE_DRAW
			   MOV R0, 0x0F
			   MOV R1, 0x03
			   MOV R3, 0x08
               MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R1, 0x05
			   MOV R3, 0x08
               CALL LINE_DRAW
			   MOV R1, 0x07
			   MOV R3, 0x08
			   CALL LINE_DRAW
			    MOV R1, 0x09
			   MOV R3, 0x08
			   CALL LINE_DRAW
			   MOV R1, 0x0D
			   MOV R3, 0x08
			   CALL LINE_DRAW
			   MOV R1, 0x0F
			   MOV R3, 0x08
			   CALL LINE_DRAW
               MOV R0, 0x0F
			   MOV R1, 0x0A
			   MOV R3, 0x03
			   MOV R10, 0x01
			   CALL LINE_DRAW
               MOV R0, 0x17
			   MOV R3, 0x03
			   CALL LINE_DRAW
               MOV R0, 0x19
			   MOV R3, 0x03
			   CALL LINE_DRAW
               MOV R0, 0x1D
			   MOV R3, 0x03
			   CALL LINE_DRAW
               MOV R0, 0x21
			   MOV R3, 0x03
			   CALL LINE_DRAW
               MOV R0, 0x19
			   MOV R1, 0x09
			   MOV R3, 0x08
			   MOV R10, 0x00
			   CALL LINE_DRAW
		       MOV R1, 0x0D
			   MOV R3, 0x08
			   CALL LINE_DRAW
			   MOV R0, 0x08
			   MOV R1, 0x06
			   MOV R3, 0x02
			   MOV R10, 0x01
			   CALL LINE_DRAW
			   MOV R0, 0x0B
			   MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R1, 0x0B
			   MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R0, 0x08
			   MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R0, 0x06
			   MOV R1, 0x08
			   MOV R3, 0x03
			   CALL LINE_DRAW
			   MOV R0, 0x0D
			   MOV R3, 0x03
			   CALL LINE_DRAW
			   MOV R0, 0x07
			   MOV R3, 0x01
			   MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R0, 0x0B
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   MOV R1, 0x0B
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   MOV R0, 0x07
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   MOV R0, 0x09
			   MOV R1, 0x06
			   MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R1, 0x0D
			   MOV R3, 0x02
			   CALL LINE_DRAW
	           MOV R0, 0x09
			   MOV R1, 0x09
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   MOV R1, 0x0A
			   MOV R3, 0x01
			   CALL LINE_DRAW
               MOV R0, 0x14
			   MOV R1, 0x17
			   MOV R2, 0x03
			   OUT R2, VGA_COLOR
			   OUT R0, VGA_COLUMN
			   OUT R1, VGA_ROW
			   CALL UPDATE_SCREEN
			   MOV R0, 0x14
			   MOV R1, 0x15
			   OUT R0, VGA_COLUMN
			   OUT R1, VGA_ROW
			   CALL UPDATE_SCREEN
               RET				                ; Return after completion of drawing static objects 			

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INTERRUPT DRIVEN DRAW TIMER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following block utilizes the TIMER input in order to create and update a timer on the VGA display.
;; This is interrupt driven when the time changes and utilizes the DRAW_DIG function in order to draw the
;; digits on the display.
;; 
;; The SECONDS and MINUTES are split into two eight bit values. Both contain BCD representations of tens of 
;; seconds/minutes in the MSBs and seconds/minutes in the LSB.
;;
;; E.G. SECONDS = 0101 0001 (This will corresond to 51 seconds on the display).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ISR_DRAW_TM:   IN R9, SECOND_ID                ; Read in the current seconds (0000 0000 - 0110 0000) 
			   AND R9,  0x0F                    ; Mask the tens of seconds
		       CMP R9, R17                      ; Is the seconds the same as the previous seconds?
		       MOV R17, R9                      ; Store previous seconds for next call
			   BREQ DRAW_10_SEC                 ; If they are the same don't redraw this digit
               LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
RND_SEC_0: 	   IN R16, RAND_NUM                 ; Read 'random' number to the color register
			   MOV R0, 0x1A                     ; Set X offset
			   MOV R1, 0x14					    ; Set Y offset
			   CALL DRAW_DIG                    ; Draw the digit
DRAW_10_SEC:   IN R9, SECOND_ID					; Read in the current tens of seconds (0000 0000 - 0110 0000)
			   LSR R9                           ; Shift tens of seconds to the LSB of R9
		       LSR R9
			   LSR R9
			   LSR R9
			   AND R9, 0x0F						; Mask top 4 bits of R9
			   CMP R9, R18					    ; Is the tens of seconds the same as the previous tens of seconds?
			   MOV R18, R9                      ; Store previous tens of seconds for next call
			   BREQ DRAW_0_MIN                  ; If they are the same don't redraw this digit
			   LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
			   IN R16, RAND_NUM                 ; Read 'random' number to the color register
			   MOV R0, 0x16                     ; Set X offset
			   MOV R1, 0x14					    ; Set Y offset
			   CALL DRAW_DIG                    ; Draw the digit
DRAW_0_MIN:	   IN R9, MINUTE_ID                 ; Read in the current minutes time (0000 0000 - 0110 0000) 
			   AND R9, 0x0F                     ; Mask the tens of minutes
			   CMP R9, R19                      ; Is the minutes the same as the previous minutes?
		       MOV R19, R9                      ; Store previous minutes for next call
			   BREQ DRAW_10_MIN                 ; If they are the same don't redraw this digit
			   LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
			   IN R16, RAND_NUM                 ; Read 'random' number to the color register
			   MOV R0, 0x10                     ; Set X offset
			   MOV R1, 0x14					    ; Set Y offset
			   CALL DRAW_DIG                    ; Draw the digit
DRAW_10_MIN:   IN R9, MINUTE_ID			        ; Read in the current tens of minutes (0000 0000 - 0110 0000)
			   LSR R9                           ; Shift tens of minutes to the LSB of R9
		       LSR R9
			   LSR R9
			   LSR R9
			   AND R9, 0x0F					    ; Mask top 4 bits of R9
			   CMP R9, R20					    ; Is the tens of minutes the same as the previous tens of minutes?
			   MOV R20, R9                      ; Store previous tens of minutes for next call
			   BREQ SKIP_10_MIN                 ; If they are the same don't redraw this digit
			   LD R3, (R9)                      ; Load the scratch location for the desired digit from the LUT
			   IN R16, RAND_NUM                 ; Read 'random' number to the color register
			   MOV R0, 0x0C                     ; Set X offset
			   MOV R1, 0x14					    ; Set Y offset
			   CALL DRAW_DIG                    ; Draw the digit
SKIP_10_MIN:   RETIE							; Return with interrupts enabled



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW LINE ON VGA SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following block utilizes the VGA_STATIC module to draw either a vertical or horizontal line of a 
;; given length on the VGA display.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LINE_DRAW:	   OUT R2, VGA_COLOR                ; Set the color of the VGA display
			   MOV R8, R1					    ; Move the X offset to a temp register
			   MOV R7, R0					    ; Move the Y offset to a temp register
			   OUT R8, VGA_ROW                  ; Set the ROW of the VGA Module
	           OUT R7, VGA_COLUMN		        ; Set the COLUMN of the VGA Module
			   CALL UPDATE_SCREEN               ; Draw screen
LINE_LOOP:     CMP R10, 0x00                    ; Compare R10 with 0
			   BREQ HORIZ_LINE					; If R10 is 0 then draw a horizontal line
			   ADD R8, 0x01					    ; Add one to Y to create a vertical line
			   BRN VERT_LINE				    ; If R10 isn't 0 draw a vertical line
HORIZ_LINE:    ADD R7, 0x01                     ; Add one to X to create a horizontal line
VERT_LINE:     OUT R7, VGA_COLUMN		        ; Set the COLUMN of the VGA Module  
	           OUT R8, VGA_ROW                  ; Set the ROW of the VGA Module
			   CALL UPDATE_SCREEN               ; Draw screen
			   SUB R3, 0x01                     ; Subtract one from length
			   BRNE LINE_LOOP					; If the whole line isn't drawn loop
			   RET								; Return when line is drawn

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW DIGIT ON VGA SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following block utilizes the VGA_STATIC module to a numeric digit on the VGA screen.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_DIG:      LD R15, (R3)                     ; Load scratch memory location from LUT in the scratch
			   MOV R14, 0x05					; 0x05 is the height of a digit
			   MOV R8, R0						; Copy X to a temp register
			   MOV R7, R1  				        ; Copy Y to a temp register
DIG_LOOP:      LD R15, (R3)	   					; Load next line of Digit
			   MOV R13, 0x03                    ; Width of a digit is 3
DIG_LINE:      LSR R15                          ; Shift LSB out of digit line data
			   BRCS ON_PIX						; If a one is shifted out turn on the current pixel
			   MOV R2, 0x00						; Otherwise turn the pixel off
			   BRN OFF_PIX					    ; Skip ON_PIX
ON_PIX:		   MOV R2, R16						; Copy random color into the color register
			   OUT R2, SSEG					    ; Output the random number for the color
OFF_PIX:	   OUT R2, VGA_COLOR				; Set color of VGA
			   OUT R7, VGA_ROW				    ; Set ROW of VGA
			   OUT R8, VGA_COLUMN				; Set Column of VGA
			   CALL UPDATE_SCREEN      			; Draw screen with current outputs
			   ADD R8, 0x01						; Go to the next pixel horizontally 
			   SUB R13, 0x01					; Subtract one from 3 
			   BRNE DIG_LINE					; DIG_LINE happends 3 times for every DIG_LOOP
			   MOV R13, 0x03					; Replenish R13 with width of digit
			   MOV R8, R0						; Recopy offset of X
			   ADD R7, 0x01					    ; Add one to Y
			   ADD R3, 0x01						; Got to next memory location for info about next line in dig
			   SUB R14, 0x01					; Subtract one from 5
			   BRNE DIG_LOOP					; DIG_LOOP happens 5 times for every DRAW_DIG call
			   RET								; Return when done drawing digit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UPDATE VGA SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following block pulses the Enable on the VGA module to process current inputs to the VGA module.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UPDATE_SCREEN: OUT R6, VGA_EN
			   OUT R5, VGA_EN
			   RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UPDATE USER INPUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following block reads the input from the NES controller, outputs it to the TX UART module, checks for
;; resets/pauses of the timer, and drives the VGA to show user inputs. A portion of this code is essentially
;; repeat thus only the first iteration will be commented throughly.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
USER_IN_UPDT:  IN R11, NES_CONTROLLER			; Read input from the NES controller
			   OUT R6, TX_CON					; Enable TX UART module
			   OUT R11, TX_DATA					; Output current user input over UART
			   OUT R5, TX_CON					; Disable TX UART module
			   CMP R11, R14						; Compare current input to previous input
			   BRNE DONT_BREAK					; If current input /= previous input continue
			   RET								; Otherwise return
DONT_BREAK:	   MOV R14, R11						; Copy input to temp register
			   CMP R11, 0xB0					; Check if Start, Select, and B are pressed
			   BRNE NO_TIMER_RST				; If they aren't don't pause timer
		       MOV R12, 0x02					; Move number for 'reset'
			   OUT R12, TIMER_CON				; Set the timer to reset
			   OUT R5, TIMER_CON				; Return timer control inputs to 0
NO_TIMER_RST:  CMP R11, 0x30                    ; Check if Start and Select are pressed
			   BRNE EXIT_TIME					; If not true skip pause logic
		       CMP R13, 0x00					; Check if we are paused or not
			   BREQ PAUSE_ON					; If we paused (R13 = 1)
			   MOV R13, 0x00					; Set state to 'un-paused'
			   OUT R13, TIMER_CON				; Un-pause timer
			   BRN EXIT_TIME					; Skip pause logic
PAUSE_ON:	   MOV R13, 0x01					; If we aren't paused (R13 = 0), set state to paused
			   OUT R13, TIMER_CON               ; Pause the timer
EXIT_TIME:     MOV R12, R11    					; Copy user input to temp register
			   AND R12, 0x40					; Mask for the bit corresponding to 'A'
			   CMP R12, 0x00					; Compare to '0'
			   BREQ OFF_A						; Branch if 'A' isn't '1'
			   MOV R2, 0xE0						; If 'A' is one set Color register to red
               BRN ON_A							; Skip Off_A
OFF_A:         MOV R2, 0x00						; If 'A' isn't '1' then set color to black
ON_A:	       OUT R2, VGA_COLOR                ; Set color on the VGA module 
               MOV R0, 0x1E						; The following code until MOV R12, R11, sets pixels that
			   MOV R1, 0x0A						; represent the buttons similar to the DRAW_CONST function
               MOV R3, 0x02						
		       MOV R10, 0x00					
			   CALL LINE_DRAW					
			   MOV R1, 0x0B
               MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R1, 0x0C
               MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R12, R11    
			   AND R12, 0x80
			   CMP R12, 0x00
			   BREQ OFF_B
			   MOV R2, 0xE0
               BRN ON_B
OFF_B:         MOV R2, 0x00
ON_B:	       OUT R2, VGA_COLOR
			   MOV R0, 0x1A
			   MOV R1, 0x0A
			   MOV R3, 0x02
		       MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R1, 0x0B
               MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R1, 0x0C
               MOV R3, 0x02
			   CALL LINE_DRAW
			   MOV R12, R11    
			   AND R12, 0x20
			   CMP R12, 0x00
			   BREQ OFF_SEL
			   MOV R2, 0xE0
               BRN ON_SEL
OFF_SEL:       MOV R2, 0x00
ON_SEL:	       OUT R2, VGA_COLOR
               MOV R0, 0x11
			   MOV R1, 0x0B
		       MOV R3, 0x01
		       MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R12, R11    
			   AND R12, 0x10
			   CMP R12, 0x00
			   BREQ OFF_STRT
			   MOV R2, 0xE0
               BRN ON_STRT
OFF_STRT:      MOV R2, 0x00
ON_STRT:	   OUT R2, VGA_COLOR
			   MOV R0, 0x14
			   MOV R1, 0x0B
		       MOV R3, 0x01
		       MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R12, R11    
			   AND R12, 0x01
			   CMP R12, 0x00
			   BREQ OFF_UP
			   MOV R2, 0xE0
               BRN ON_UP
OFF_UP:        MOV R2, 0x00
ON_UP:	       OUT R2, VGA_COLOR
			   MOV R0, 0x09
			   MOV R1, 0x07
			   MOV R3, 0x01
               MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R1, 0x08
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   MOV R12, R11    
			   AND R12, 0x04
			   CMP R12, 0x00
			   BREQ OFF_DOWN
			   MOV R2, 0xE0
               BRN ON_DOWN
OFF_DOWN:      MOV R2, 0x00
ON_DOWN:	   OUT R2, VGA_COLOR
		       MOV R0, 0x09
			   MOV R1, 0x0B
			   MOV R3, 0x01
		       MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R1, 0x0C
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   MOV R12, R11    
			   AND R12, 0x02
			   CMP R12, 0x00
			   BREQ OFF_LEFT
			   MOV R2, 0xE0
               BRN ON_LEFT
OFF_LEFT:      MOV R2, 0x00
ON_LEFT:	   OUT R2, VGA_COLOR
			   MOV R0, 0x07
			   MOV R1, 0x09
		       MOV R3, 0x01
		       MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R1, 0x0A
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   MOV R12, R11    
			   AND R12, 0x08
			   CMP R12, 0x00
			   BREQ OFF_RIGHT
			   MOV R2, 0xE0
               BRN ON_RIGHT
OFF_RIGHT:     MOV R2, 0x00
ON_RIGHT:	   OUT R2, VGA_COLOR
	           MOV R0, 0x0B
			   MOV R1, 0x09
			   MOV R3, 0x01
		       MOV R10, 0x00
			   CALL LINE_DRAW
			   MOV R1, 0x0A
			   MOV R3, 0x01
			   CALL LINE_DRAW
			   RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ISR SETUP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The following block setups the branch to ISR_DRAW_TM for handling Interrupt events produced from the
;; interrupt handler.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;i;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.ORG 0x3FF
BRN ISR_DRAW_TM					; ISR_DRAW_TM is the Interrupt Service Routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
