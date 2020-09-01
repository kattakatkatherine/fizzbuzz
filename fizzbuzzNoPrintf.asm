section .data
	fizzbuzz: dd "Fizz", 4, 3 
			  dd "Buzz", 4, 5

	fzn equ 2				; number of phrases
	min equ 1				; start at 1
	max equ 100				; end at 100
	base equ 10				; print output in base 10
	
	newln db 0x0a

section .text
	global _start

_start:
	mov eax, min-1			; start counter
	mov ebp, esp			; preserve esp

.loop:
	mov esp, ebp			; restore esp
	cmp eax, max			; counter at max? 
	jnl .exit				; then exit
	inc eax					; increment counter
	xor ebx, ebx			; clear fizz/buzz indicator
	xor edx, edx			; clear offset

.top:
	mov ecx, edx				; offset
	add ecx, fizzbuzz			; add pointer to offset
	push ecx					; string
	push dword [fizzbuzz+4+edx]	; length
	mov ecx, [fizzbuzz+8+edx]	; divisible?
	call .compare				; then print
	
	add edx, 12				; add offset
	cmp edx, fzn*12			; done?
	jl .top					; repeat

	cmp ebx, 0				; fizz/buzz?
	jne .newline			; then repeat

	pushad					; preserve registers
	mov ebx, base			; base to convert to
	xor ecx, ecx			; start counter

.toascii:
	inc ecx					; increment counter
	xor edx, edx			; clear edx
	div ebx					; divide number by base
	push edx				; push the remainder

	cmp eax, 0				; pushed all digits?
	jne .toascii			; repeat if not

.printnum:
	pop edx					; pop digit
	mov ebp, esp			; preserve esp

	sub esp, 4				; allocate space in stack
	mov [esp], edx			; move digit to esp
	add [esp], byte '0'		; convert digit to ascii
	push esp				; string
	push 1					; length
	call .print				; print

	mov esp, ebp			; restore esp
	loop .printnum			; loop
	mov esp, ebp			; restore esp
	popad					; restore registers

.newline:
	push dword newln		; newline
	push 1					; length
	call .print				; print

	jmp .loop				; repeat

.exit:
	mov eax, 1				; sys_exit
	xor ebx, ebx			; success
	int 0x80				; syscall

.compare:
	pushad					; preserve registers
	xor edx, edx			; clear edx
	div ecx					; divide
	cmp edx, 0				; remainder?
	popad					; restore registers
	jne .return				; then don't print

.print:
	pushad					; preserve registers
	mov ebp, esp			; preserve esp
	add esp, 36				; align stack

	mov eax, 4				; sys_write
	mov ebx, 1				; stdout
	pop edx					; string
	pop ecx					; length
	int 0x80				; syscall

	mov esp, ebp			; restore esp
	popad					; restore registers
	inc ebx					; set fizz/buzz indicator 

.return:
	ret						; return
