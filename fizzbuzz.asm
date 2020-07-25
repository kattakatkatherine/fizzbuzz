section .data
	fizzbuzz db "FizzBuzz", 0x0a, 0x00
	fizz db "Fizz", 0x0a, 0x00
	buzz db "Buzz", 0x0a, 0x00
	num db "%d", 0x0a, 0x00

section .text
	global main
	extern printf

main:
	mov eax, 0

iterate:
	inc eax

	mov ecx, 15
	mov ebx, fizzbuzz
	call compare

	mov ecx, 3
	mov ebx, fizz
	call compare

	mov ecx, 5
	mov ebx, buzz
	call compare

	mov ebx, num

print:
	push eax
	mov ebp, esp
	push ebx
	call printf
	mov esp, ebp
	pop eax

	cmp eax, 100
	jl iterate

exit:
	mov eax, 1				; sys_exit
	mov ebx, 0				; success
	int 0x80

compare:
	xor edx, edx
	push eax
	div ecx
	pop eax
	cmp edx, 0
	jne notEqual
		jmp print
	notEqual:
	ret