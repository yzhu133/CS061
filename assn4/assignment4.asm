;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Yuchen Zhu
; Email: yzhu133@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 023
; TA: Shirin
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R4
;=================================================================================

.ORIG x3000		
;-------------
;Instructions
;-------------
; output intro prompt
    prog_begin
        LD R0, introPromptPtr
        PUTS
; Set up flags, counters, accumulators as needed
    load_setup
        AND R1, R1, #0
        LD R5, sub_times_ten
        AND R6, R6, #0 ;if minus then R6 = 1
        LD R3, max_counter
        AND R4, R4, #0
        
        
;Input check
    Input_check
; Get first character, test for '\n', '+', '-', digit/non-digit 	
    	GETC
    	OUT
    	
    	LD R2, hex0A
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check if iunput = \n
    	BRZ first_newline
    	
    	LD R2, hex2B
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check if iunput = +
    	BRZ first_plus
    	
    	LD R2, hex2D
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check if iunput = -
    	BRZ first_minus
    	
    	LD R2, hex30
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check input num less than hex30 (below hex30)
    	BRN first_error
    	
    	LD R2, hex39
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check input num more than hex39 (above hex39)
    	BRP first_error
    	
    	BR first_num
    	
Input_check_2
; Get first character, test for '\n', '+', '-', digit/non-digit 	
    	GETC
    	OUT
    	
    	LD R2, hex0A
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check if iunput = \n
    	BRZ first_newline
    	
    	LD R2, hex2B
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check if iunput = +
    	BRZ first_error
    	
    	LD R2, hex2D
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check if iunput = -
    	BRZ first_error
    	
    	LD R2, hex30
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check input num less than hex30 (below hex30)
    	BRN first_error
    	
    	LD R2, hex39
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check input num more than hex39 (above hex39)
    	BRP first_error
    	
    	BR first_num
; is very first character = '\n'? if so, just quit (no message)!
    first_newline
        BR QUIT
; is it = '+'? if so, ignore it, go get digits
    first_plus
        BR Input_check_2
; is it = '-'? if so, set neg flag, go get digits
	first_minus
	    ADD R6, R6, #1
	    BR Input_check_2
; is it < '0'? if so, it is not a digit	- o/p error message, start over
    first_error
        LD R0, errorMessagePtr
        PUTS 
        BR prog_begin
; if none of the above, first character is first numeric digit - convert it to number & store in target register!
	first_num
	    LD R2, hex30
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;converts hex to dec
	    ADD R1, R1, R2
	    BR rem_4_num
; Now get remaining digits from user in a loop (max 5), testing each to see if it is a digit, and build up number in accumulator
    rem_4_num
        
        GETC
        OUT
        
        LD R2, hex0A
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check if iunput = \n
    	BRZ end_loop
        
        JSRR R5 ;multiply by 10
        
        
        LD R2, hex30
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check input num less than hex30 (below hex30)
    	BRN loop_error
    	
    	LD R2, hex39
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;check input num more than hex39 (above hex39)
    	BRP loop_error
    	
    	LD R2, hex30
        NOT R2, R2
        ADD R2, R2, #1
    	ADD R2, R0, R2 ;converts hex to dec
    	BR loop_num

        loop_error
            LD R0, errorMessagePtr
            PUTS
            BR prog_begin
        
        loop_num
            ADD R1, R1, R2
            AND R2, R2, #0
            ADD R2, R2, R1
        
        ADD R3, R3, #-1
        BRP rem_4_num
        
; remember to end with a newline
    end_loop
    ADD R4, R4, R1
    ADD R6, R6, #-1
    BRN END_OF_PROG
    
    not_val
        NOT R4, R4
        ADD R4, R4, #1
    
    END_OF_PROG
    	LD R0, hex0A
    	OUT
	
    QUIT
HALT

;---------------	
; Program Data
;---------------
input .blkw #1
max_counter .fill #4

hex0A .fill x0A ;newline
hex2B .fill x2B ;plus sign
hex2D .fill x2D ;minus sign 
hex30 .fill x30 ;dec0 (hex->dec) (lower thresh)
hex39 .fill x39 ;dec9 (uppre thresh)

sub_times_ten .fill x3400
introPromptPtr  .FILL xB000
errorMessagePtr .FILL xB200

.END

;===========================
;sub times ten
;===========================
.orig x3400
    ST R0, R0_BACKUP
    ST R2, R2_BACKUP
    ST R7, R7_BACKUP
    
    LD R0, dec10
    ST R1, loop_in
    LD R2, loop_in
    
    mult_ten_loop
        ADD R1, R1, R2
        ADD R0, R0, #-1
    BRP mult_ten_loop
    
    LD R0, R0_BACKUP
    LD R2, R2_BACKUP
    LD R7, R7_BACKUP
    
    RET
loop_in .blkw #1
dec10 .fill #9

R0_BACKUP .blkw #1
R2_BACKUP .blkw #1
R7_BACKUP .blkw #1
.end

;------------
; Remote data
;------------
.ORIG xB000	 ; intro prompt
.STRINGZ	 "Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"

.END					
					
.ORIG xB200	 ; error message
.STRINGZ	 "ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
