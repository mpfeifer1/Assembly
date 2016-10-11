@This program also takes in a string of chars, then returns the checksum
@ it uses local variables, preventing it from doubling

	@ declare variables
	.data
j:	.word 4095

	@ declare strings
str1:	.asciz "Enter text (ctrl-D to end): "
	.align 2
str2:	.asciz "%s\n"
	.align 2
str3:	.asciz "\nThe checksum is %08X\n"
	.align 2

	@ create array of chars
	.bss
buffer:	.space 4096



	.text
	.globl main

checksum:
        stmfd sp!, {lr} @ push link register to stack

        @ main loop in checksum
        mov r2, #0      @ i = 0
        mov r3, #0	@ load sum (0) into r3
chloop:
        ldr r1, =buffer @ load buffer's address into r1
        ldrb r0, [r1,+r2]@ r0 = buffer[i]
        cmp r0, #0      @ compare 0 to buffer[i]
        beq endchloop     @ buffer[i] == 0, break loop
        add r3, r3, r0  @ sum += buffer[i]
        add r2, r2, #1  @ increment i
        b chloop

        @ exit the loop
endchloop:
        @ exit the function
        ldmfd sp!, {lr}
        mov r0, r3 @ return sum in r0
        mov pc, lr



main:
	@ push link register to stack
	stmfd sp!, {lr}

	@ prompt for text
	ldr r0, =str1
	bl printf

	@ do while loop
	mov r4, #0	@ load i (0) into r4
loop:	
	bl getchar	@ load a character into r0
	cmp r0, #-1	@ compare the character to -1
	beq endloop	@ if character is -1, break out
	ldr r1, =buffer @ load buffer's address into r1
	strb r0, [r1,+r4]@ store into buffer (shifted i) r0
	ldr r2, =j	@ load 4095 into r2
	add r4, r4, #1	@ add 1 to i
	cmp r2, r4	@ compare j to i
	bge loop	@ if j > i goto loop

	@ after the loop
endloop:
	ldr r1, =buffer @ load buffer's address into r1
	mov r2, #0	@ load 0 into r2
        str r2, [r1,+r4]@ store 0 into buffer[i]

	@ print buffer
	ldr r0, =str2	@ load string 2 as first arg
	ldr r1, =buffer	@ load buffer as second arg
	bl printf	@ print

	@ call checksum
	bl checksum
	 
	@ print checksum
	mov r1, r0	@ move checksum to 2rd argument
	ldr r0, =str3	@ load string to print
	bl printf	@ print

	@ call checksum
        bl checksum

        @ print checksum
        mov r1, r0      @ move checksum to 2rd argument
        ldr r0, =str3   @ load string to print
        bl printf       @ print
	
	@ exit the program
	ldmfd sp!, {lr}
	mov r0, #0
	mov pc, lr
