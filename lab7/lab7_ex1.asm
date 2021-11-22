;=================================================
; Name: Yuchen Zhu
; Email: yzhu133@ucr.edu
; 
; Lab: lab 7, ex 1
; Lab section: 023
; TA: Shirin
; 
;=================================================

; test harness
.orig x3000
	AND R0, R0 #0
	ADD R0, R0, #5
	
	LD R5, FACT_ADDR
	JSRR R5
	
halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
FACT_ADDR .fill x3100



;===============================================================================================
.end

; subroutines:
;======================
;fact subroutine
;======================
.orig x3100
FACT
    ST R1, SAVE1_3100
    
    ADD R1, R0, #-1
    BRz DONE
    
    ADD R1, R0, #0
    ADD R0, R1, #-1
    JSR FACT
    LD R5, MUL_ADDR
    JSRR R5

DONE
    LD R1, SAVE1_3100
ret
MUL_ADDR .fill x3200
SAVE1_3100 .blkw #1

.end

;=======================
;mult subroutine
;=======================
.orig x3200
MUL
    ST R2, SAVE2_3200
    
    AND R2, R2, #0 ;maybe
    ADD R2, R0, #0
    AND R0, R0, #0

LOOP
    ADD R0, R0, R1
    ADD R2, R2, #-1
    BRP LOOP
    
    LD R2, SAVE2_3200

ret
SAVE2_3200 .blkw #1

.end




