include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
	MAXTEXTSIZE equ 50
 	__flags dw ? 
	__descar dd ? 
	oldcw dw ? 
	__auxConc db MAXTEXTSIZE dup (?), '$'
	__resultConc db MAXTEXTSIZE dup (?), '$'
	msgPRESIONE db 0DH, 0AH,'Presione una tecla para continuar...','$'
	_newLine db 0Dh, 0Ah,'$'
vtext db 100 dup('$')
 
;Declaracion de variables de usuario
	@a	dd	?
	@d	dd	?
	@b	db	MAXTEXTSIZE dup (?),'$'
	@c	db	MAXTEXTSIZE dup (?),'$'
	@_se_declararon_variables	db	'Se declararon variables','$',26 dup (?)
	@_uso_de_comentarios	db	'Uso de comentarios','$',31 dup (?)
	@_constantes_numericas	db	'Constantes numericas','$',29 dup (?)
	@_0p12	dd	0.120
	@aux	DD 0.0

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX

	MOV ES, AX


;Comienzo codigo de usuario


	LEA DX, @_se_declararon_variables 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, @_uso_de_comentarios 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, @_constantes_numericas 
	MOV AH, 9
	INT 21H
	newline
	fld @_0p12
	fstp @a

;finaliza el asm
 	mov ah,4ch
	mov al,0
	int 21h

STRLEN PROC NEAR
	mov BX,0

STRL01:
	cmp BYTE PTR [SI+BX],'$'
	je STREND
	inc BX
	jmp STRL01

STREND:
	ret

STRLEN ENDP

COPIAR PROC NEAR
	call STRLEN
	cmp BX,MAXTEXTSIZE
	jle COPIARSIZEOK
	mov BX,MAXTEXTSIZE

COPIARSIZEOK:
	mov CX,BX
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret

COPIAR ENDP

CONCAT PROC NEAR
	push ds
	push si
	call STRLEN
	mov dx,bx
	mov si,di
	push es
	pop ds
	call STRLEN
	add di,bx
	add bx,dx
	cmp bx,MAXTEXTSIZE
	jg CONCATSIZEMAL

CONCATSIZEOK:
	mov cx,dx
	jmp CONCATSIGO

CONCATSIZEMAL:
	sub bx,MAXTEXTSIZE
	sub dx,bx
	mov cx,dx

CONCATSIGO:
	push ds
	pop es
	pop si
	pop ds
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret

CONCAT ENDP
END START; final del archivo. 
