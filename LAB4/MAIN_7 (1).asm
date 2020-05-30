STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
STACKSEG ENDS

DATASEG SEGMENT PARA 'DATA'
    RMSG DB 'Enter matrix size: $'
    RESMSG DB 'New matrix:$'
    DECR DW 0
	COUNT DB 0
    SIZE_MATRIX DB 0
    MATRIX DB 9 * 9 DUP(?)
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


EQUAL:
	ADD COUNT, 1
	RET	
	
CHECK_H:
    CMP DL, '_'
    JE EQUAL
	ret

	
AtoFCASE:
	INC AL
    RET_PROC:
    RET
	
MAIN:
	; Датасег загрузка
    MOV AX, DATASEG
    MOV DS, AX

    MOV AH, 9
    MOV DX, OFFSET RMSG
    INT 21H
	; размер матрицы
    CALL INSYMB
    MOV SIZE_MATRIX, AL
    SUB SIZE_MATRIX, '0'
    CALL CRLF
	; Ввод матрицы
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
    MOV BX, 0
	; Рабочая часть программы

    INPUTMAT:
		MOV AL, 0
		MOV COUNT, 0
	
		delstr:
			MOV DH, 0
			ADD COUNT, 30H
			MOV DL, COUNT
			MOV AH, 02H
			INT 21H
        MOV CL, SIZE_MATRIX
        INPUTROW:
            MOV DL, MATRIX[BX]
            CALL CHECK_H
			mov matrix[bx], DL
            INC BX
            LOOP INPUTROW
        MOV CL, SIZE_MATRIX
        SUB CX, DECR
		INC DECR
		JE delstr
        LOOP INPUTMAT

	CALL CRLF

    MOV DECR, 0

    MOV BX, 0
	; Вывод матрицы
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
