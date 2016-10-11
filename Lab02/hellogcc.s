	.data
msg:
	.ascii "Hello World!\n"
len	= . - msg

	.text
.globl	main

main:
	ldr r0, =msg
	bl printf
	mov r0, #0
	mov pc, lr
