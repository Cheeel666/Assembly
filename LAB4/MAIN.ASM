STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
STACKSEG ENDS

DATASEG SEGMENT PARA 'DATA'
    RMSG DB 'Enter matrix size: $'
    RESMSG DB 'New matrix:$'
    DECR DW 0
	
    SIZE_MATRIX DB 0
    MATRIX DB 9 * 9 DUP(?)
	CX_CPY DW 0
	AX_CPY DW 0
	BX_CPY DW 0
	COUNTER DB 0
	
DATASEG ENDS

CODESEG SEGMENT PARA 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG

; Ввод символа
INSYMB:
    MOV AH, 1
    INT 21H
    RET

; Выввод символа
OUTSYMB:
    MOV AH, 2
    INT 21H
    RET

; Новая строка
CRLF:
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    RET

; Выввод пробела
PRINTSPACE:
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    RET

;Замена на *


; Проверка на h число
CHECK_M:
	MOV BX_CPY, BX
	MOV AX_CPY, AX
	MOV CX_CPY, CX
	
	MOV CL, SIZE_MATRIX
	MOV CH, 0
	MOVE_MATR1:
		CMP MATRIX[BX], '_'
		JE COUNT
		COUNT:
			INC COUNTER
		
		INC BX
		LOOP MOVE_MATR1
	
	
		
	MOV AL, COUNTER
	MOV AH, 0
	MOV DX, 2
	DIV DX
	MOV DL, COUNTER
	MOV DH, DL
	CALL OUTSYMB
	CMP AH, 0
	JE REM_STR
	
	MOV AX, AX_CPY
	MOV BX, BX_CPY
	MOV CX, CX_CPY
	RET
		



REM_STR:
	
    AtoFCASE:
    CMP DL,'_'
    JE CHANGE_M
	RET
	
    CHANGE_M:
	MOV CL, SIZE_MATRIX
	
	MOV AX, BX_CPY
	DIV SIZE_MATRIX
	MOV BL, SIZE_MATRIX
	MOV AL, AH
	MOV BX, BX_CPY
	MOV AH, 0
	MOV AL, SIZE_MATRIX
	MOV BX, DECR
	MOV BH, 0
	MOV BX, AX
	MOV CH, 0
	MOVE_MATR:
		MOV MATRIX[BX], 0
		INC BX
		LOOP MOVE_MATR
	MOV DL, 0
	RET
	
    RET_PROC:
    RET
	

MAIN:
    MOV AX, DATASEG
    MOV DS, AX

    MOV AH, 9
    MOV DX, OFFSET RMSG
    INT 21H

    CALL INSYMB
    MOV SIZE_MATRIX, AL
    SUB SIZE_MATRIX, '0'
    CALL CRLF

    MOV BX, 0
    INMAT:
        MOV CL, SIZE_MATRIX
        INROW:
            CALL INSYMB
            MOV MATRIX[BX], AL
            INC BX
            CALL PRINTSPACE
            LOOP INROW
        CALL CRLF
        MOV CL, SIZE_MATRIX
        SUB CX, DECR
		INC DECR
	LOOP INMAT
     
    CALL CRLF

    MOV AH, 9
    MOV DX, OFFSET RESMSG
    INT 21H
    CALL CRLF

    MOV DECR, 0
	MOV CL, SIZE_MATRIX
    MOV BX, 0
	
    INPUTMAT:
		CALL CHECK_M
		ADD BL, SIZE_MATRIX
		INC DECR
        LOOP INPUTMAT

	CALL CRLF

    MOV DECR, 0

    MOV BX, 0

    OUTMAT:
        MOV CL, SIZE_MATRIX
        OUTROW:
            MOV DL, MATRIX[BX]
            MOV DH, DL
            CALL OUTSYMB
            INC BX
            CALL PRINTSPACE
            LOOP OUTROW
		
        CALL CRLF
		
		MOV CL, SIZE_MATRIX
        SUB CX, DECR
		INC DECR
        LOOP OUTMAT

    MOV AX, 4C00H
    INT 21H
CODESEG ENDS
END MAIN