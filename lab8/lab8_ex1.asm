;=================================================
; Name: Yuchen Zhu
; Email: yzhu133@ucr.edu
; 
; Lab: lab 8, ex 1
; Lab section: 023
; TA: Shirin
; 
;=================================================
.orig x3000
    LD R1, array_ptr
    LD R2, SUB_GET_STRING_PTR
    
    JSRR R2


halt
SUB_GET_STRING_PTR .fill x3200
array_ptr .fill x4000

.end


;----------------------------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
                ; terminated by the [ENTER] key (the "sentinel"), and has stored
                ; the received characters in an array of characters starting at (R1).
                ; the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of non-sentinel characters read from the user.
; R1 contains the starting address of the array unchanged.
;-----------------------------------------------------------------------------------------------------------------
.orig x3200
    STORE_VALS
        ST R1, BACKUPR1
        ST R2, BACKUPR2
        ST R3, BACKUPR3
        ST R4, BACKUPR4
        ST R6, BACKUPR6
        ST R7, BACKUPR7
    
    AND R2, R2, #0
    LD R3, hexA
        NOT R3, R3
        ADD R3, R3, #1
    AND R5, R5, #0
    
    LOOP_START
        getc
        ADD R4, R0, R3
        BRZ END_STRING
        out
        
        STR R0, R1, #0
        ADD R1, R1, #1
        ADD R5, R5, #1
        BR LOOP_START
    
    END_STRING
        STR R2, R1, #0
    
    LOAD_VALS
        LD R1, BACKUPR1
        LD R2, BACKUPR2
        LD R3, BACKUPR3
        LD R4, BACKUPR4
        LD R6, BACKUPR6
        LD R7, BACKUPR7
RET

hexA .fill xA


BACKUPR1 .blkw #1
BACKUPR2 .blkw #1
BACKUPR3 .blkw #1
BACKUPR4 .blkw #1

BACKUPR6 .blkw #1
BACKUPR7 .blkw #1
.end


.orig x4000
.blkw #30
.end