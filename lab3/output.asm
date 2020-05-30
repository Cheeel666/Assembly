PUBLIC newline
PUBLIC endprog
PUBLIC output
STK SEGMENT PARA STACK 'STACK'
    db 200 DUP (0)
STK ENDS

SEGDATA SEGMENT PARA COMMON 'DATA'
SEGDATA ENDS

SEGCODE SEGMENT PARA PUBLIC 'CODE'
    assume CS:SEGCODE, DS:SEGDATA, SS:STK

output proc far
	mov al, cl
	mov ah, 2 ; выводим в консоль
	mov dl, al
	int 21h
	ret
output endp

newline proc far
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    ret
newline endp

endprog proc far	
    mov ax, 4c00h
    int 21h
endprog endp

SEGCODE ENDS
END
