	.data
str1:	.asciz "%d"
	.align 2
str2:	.asciz "Enter an integer: "
	.align 2
str3:	.asciz "Enter another integer: "
	.align 2
str4:	.asciz "The sum is: %d \n"
	.align 2
m:	.word 0
n:	.word 0

	.text
	.globl main
main:	stmfd sp!, {lr}

        @printf output an int
        ldr r0, =str2
        bl printf

	@scanf into m
	ldr r0, =str1
	ldr r1, =m
	bl scanf

	@printf output another int
	ldr r0, =str3
	bl printf

        @scanf into n
        ldr r0, =str1
        ldr r1, =n
        bl scanf

	@ add them together
        ldr r2, =m
	ldr r2, [r2]
        ldr r1, =n
	ldr r1, [r1]
        add r1, r2, r1

	@ printf total
	ldr r0, =str4
        bl printf

	@ quit
	ldmfd sp!, {lr}
	mov r0, #0
	mov pc, lr
	.end
