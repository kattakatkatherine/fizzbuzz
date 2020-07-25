section .data
	fizzbuzz db "FizzBuzz", 0x0a, 0x00
	fizz db "Fizz", 0x0a, 0x00
	buzz db "Buzz", 0x0a, 0x00
	num db "%d", 0x0a, 0x00

section .text
	global main
	extern printf

main:
	mov eax, 0				; start counter

iterate:
	inc eax					; increment counter

	mov ecx, 15				; divisible by 15?
	mov ebx, fizzbuzz		; then fizzbuzz
	call compare

	mov ecx, 3				; divisible by 3?
	mov ebx, fizz			; then fizz
	call compare

	mov ecx, 5				; divisible by 5?
	mov ebx, buzz			; then buzz
	call compare

	mov ebx, num			; otherwise, print the number

print:
	push eax				; preserve counter
	mov ebp, esp			; preserve esp
	push ebx				; push string
	call printf				; print string
	mov esp, ebp			; restore esp
	pop eax					; restore eax

	cmp eax, 100			; counter < 100?
	jl iterate				; then repeat

exit:
	mov eax, 1				; sys_exit
	mov ebx, 0				; success
	int 0x80				; syscall

compare:
	xor edx, edx
	push eax				; preserve counter
	div ecx					; divide counter by value
	pop eax					; restore counter
	cmp edx, 0				; remainder is 0?
	jne notEqual
		jmp print			; then print
	notEqual:
	ret
