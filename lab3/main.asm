EXTERN newline: far
EXTERN endprog: far
EXTERN output: far

SEGDATA SEGMENT PARA COMMON 'DATA'
	number db 1
SEGDATA ENDS

SEGCODE SEGMENT PARA PUBLIC 'CODE'
    assume CS:SEGCODE, DS:SEGDATA
main:
    mov	ah, 01h ;считываем символ
	int	21h

	sub	al, 30h ;преобразуем строку в число 
	add al, 17 ; делаем что-то, например +4 :)
	add al, 30h ; преобразуем число снова в строку для вывода
	mov cl, al
	call newline
	call output
	call endprog
	
SEGCODE ENDS
END main
