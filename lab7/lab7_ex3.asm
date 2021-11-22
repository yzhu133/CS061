;=================================================
; Name: Yuchen Zhu
; Email: yzhu133@ucr.edu
; 
; Lab: lab 7, ex 3
; Lab section: 023
; TA: Shirin
; 
;=================================================

; test harness
.orig x3000
    LD R6, STACK_ADDR

	AND R0, R0 #0
	ADD R0, R0, #5
	
	LD R5, FACT_ADDR
	JSRR R5
	
    halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
FACT_ADDR .fill x3100
STACK_ADDR .fill xFE00


;===============================================================================================
.end

; subroutines:
;======================
;fact subroutine
;======================
.orig x3100
FACT
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R1, R6, #0
    
    ADD R1, R0, #-1
    BRz DONE
    
    ADD R1, R0, #0
    ADD R0, R1, #-1
    
    ;LD R4, FACT
    ;JSRR R4
    JSR FACT
    
    LD R5, MUL_ADDR
    JSRR R5

DONE
    LDR R1, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    ret

MUL_ADDR .fill x3200


.end

;=======================
;mult subroutine
;=======================
.orig x3200
MUL
    ADD R6, R6, #-1
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R2, R6, #0
    
    ;AND R2, R2, #0 ;maybe
    ADD R2, R0, #0
    AND R0, R0, #0

LOOP
    ADD R0, R0, R1
    ADD R2, R2, #-1
    BRP LOOP
    
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1

    ret
SAVE2_3200 .blkw #1
SAVE7_3200 .blkw #1


.end
