; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Yuchen Zhu
; Email: yzhu133@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 023
; TA: Shirin
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
; PUT ALL YOUR CODE AFTER THE main LABEL
;=================================================================================

;---------------------------------------------------------------------------------
;  Initialize program by setting stack pointer and calling main subroutine
;---------------------------------------------------------------------------------
.ORIG x3000

; initialize the stack
ld r6, stack_addr

; call main subroutine
lea r5, main
jsrr r5

;---------------------------------------------------------------------------------
; Main Subroutine
;---------------------------------------------------------------------------------
main
    LEA R1, user_string
    LD R6, stack_addr
    ADD R6, R6, #-1
; get a string from the user
    LD R4, get_user_string_addr
    LEA R2, user_prompt
    JSRR R4

; find size of input string
    LD R4, strlen_addr
    JSRR R4

; call palindrome method
    ADD R2, R2, R1
    ADD R2, R2, #-1
    LD R4, palindrome_addr
    JSRR R4

; print the result to the screen
    LEA R0, result_string
    PUTS

PRINT_START_PROMPT
    AND R0, R0, #0
    ADD R0, R3, R0
    BRz PRINT_IS_PALI

PRINT_IS_NOT_PALI
    LEA R0, not_string
    PUTS
    
PRINT_IS_PALI
    LEA R0, final_string
    PUTS

HALT

;---------------------------------------------------------------------------------
; Required labels/addresses
;---------------------------------------------------------------------------------

; Stack address ** DO NOT CHANGE **
stack_addr           .FILL    xFE00 ;fixed now!

; Addresses of subroutines, other than main
get_user_string_addr .FILL    x3200
strlen_addr          .FILL    x3300
palindrome_addr      .FILL	  x3400


; Reserve memory for strings in the progrtam
user_prompt          .STRINGZ "Enter a string: "
result_string        .STRINGZ "\nThe string is "
not_string           .STRINGZ "not "
final_string         .STRINGZ	"a palindrome\n"

; Reserve memory for user input string
user_string          .BLKW	  100

.END

;---------------------------------------------------------------------------------
; get_user_string - gets a user string 
;
; parameter: R1 - The start address of where string should be stored, R2 - User prompt 
;                 screen addresss R6 - stack add
;
; returns: n/a
;---------------------------------------------------------------------------------
.ORIG x3200
get_user_string
    STR R7, R6, #0 
    ADD R6, R6, #-1
    STR R5, R6, #0 
    ADD R6, R6, #-1
    STR R4, R6, #0 
    ADD R6, R6, #-1
    STR R1, R6, #0
    ADD R6, R6, #-1
    STR R0, R6, #0
    ADD R6, R6, #-1
    
    LD R5, hexA
        NOT R5, R5
        ADD R5, R5, #1
        
PRINT_USER_PROMPT
    AND R0, R0, #0
    ADD R0, R2, R0
    PUTS
    
LOOP_START
    GETC
    ADD R4, R5, R0
    BRZ IS_ENTER
    OUT
    STR R0, R1, #0
    ADD R1, R1, #1
    BR LOOP_START
    
IS_ENTER
    STR R4, R1, #0
    
    ADD R6, R6, #1
    LDR R0, R6, #0 
    ADD R6, R6, #1
    LDR R1, R6, #0 
    ADD R6, R6, #1
    LDR R4, R6, #0
    ADD R6, R6, #1
    LDR R5, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0

RET
hexA .fill xA;

.END

;---------------------------------------------------------------------------------
; strlen - compute the length of a zero terminated string
;
; parameter: R1 - the address of a zero terminated string, R6 - stack add
;
; returns: R2 - The length of the string
;---------------------------------------------------------------------------------
.ORIG x3300
strlen
    STR R7, R6, #0 
    ADD R6, R6, #-1
    STR R3, R6, #0 
    ADD R6, R6, #-1
    STR R1, R6, #0 
    ADD R6, R6, #-1
    
    AND R2, R2, #0
    
COUNT_LOOP
    LDR R3, R1, #0
    BRZ null_terminated
    ADD R2, R2, #1
    ADD R1, R1, #1
    BR COUNT_LOOP
    
null_terminated
    ADD R6, R6, #1
    LDR R1, R6, #0 
    ADD R6, R6, #1
    LDR R3, R6, #0 
    ADD R6, R6, #1
    LDR R7, R6, #0 
RET

.END

;---------------------------------------------------------------------------------
; palindrome - determines if string is a palidrome
;
; parameter: R1 - beginning address of a zero terminated string, R2 - ending address 
;            of a zero terminated strin, R6 - stack add
;
; returns: R3 - 0 is string is a palindrome and 1 if string is not a palindrome
;---------------------------------------------------------------------------------
.ORIG x3400
palindrome
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R5, R6, #0
    ADD R6, R6, #-1
    STR R4, R6, #0
    ADD R6, R6, #-1
    
    NOT R4, R2
    ADD R4, R4, #1
    ADD R5, R4, R1
    BRZP IS_MIDDLE
    
    LDR R4, R1, #0
    NOT R4, R4
    ADD R4, R4, #1
    LDR R5, R2, #0
    
    ADD R5, R4, R5
    BRZ IS_EQUAL
    BR NOT_PALINDROME
    
    
    
IS_MIDDLE
    AND R3, R3, #0
    BR ENDING
    
IS_EQUAL
    ADD R1, R1, #1
    ADD R2, R2, #-1
    JSR palindrome
    BR ENDING
    
NOT_PALINDROME
    AND R3, R3, #0
    ADD R3, R3, #1
    BR ENDING
    
ENDING
    ADD R6, R6, #1
    LDR R4, R6, #0
    ADD R6, R6, #1
    LDR R5, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    
    RET

.END




