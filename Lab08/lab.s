@@ This program makes a table for the really ugly function described in str1

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ define variables

	.data
str1:	.asciz	"This program will create a table for f(x) where\n     x^3-x^2-2x \nf(x)=-----------\n     (x-2)^4\n     ------- +3\n        11\n"
	.align	2
str2:	.asciz	"Enter lower bound: "
	.align	2
str3:	.asciz	"Enter upper bound: "
	.align	2
str4:	.asciz	"%s"
	.align	2
str5:	.asciz	"Enter a number of rows: "
	.align	2
str6:	.asciz	"\n"
	.align	2
str7:	.asciz	"%d"
	.align	2

lo:	.asciz	"0.0"
	.align	4

hi:	.asciz	"0.0"
	.align	4

rows:	.word	0
	.align	4

step:	.asciz	"0.0"
	.align	4


	.text
	.globl	main
main:	stmfd	sp!, {lr}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ get input

	ldr	r0, =str1	@ load string to print
	bl	printf		@ print string

	ldr	r0, =str2	@ load low prompt
	bl	printf		@ print

	ldr	r0, =str4	@ load string to scan
	ldr	r1, =lo		@ load low value
	bl	scanf		@ scan

	ldr	r0, =str3	@ load high prompt
	bl	printf		@ print

	ldr	r0, =str4	@ load string to scan
	ldr	r1, =hi		@ load high value
	bl	scanf		@ scan

	ldr	r0, =str5	@ load row prompt
	bl	printf		@ print

	ldr	r0, =str7	@ load string to scan
	ldr	r1, =rows	@ load rows
	bl	scanf		@ scan

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ calculate step

	ldr	r0, =lo		@ make lo parameter 1
	mov	r1, #8		@ 16 frac bits
	bl	strtoSfixed	@ convert lo to fixed
	mov	r4, r0		@ save lo into memory

        ldr     r0, =hi         @ make hi parameter 1
        mov     r1, #8		@ 16 frac bits
        bl      strtoSfixed     @ convert lo to fixed
        mov     r5, r0          @ save hi into memory

	sub	r9, r5, r4	@ range = hi - lo, save to r9

	ldr	r1, =rows	@ load rows' address as second parameter
	ldr	r1, [r1]	@ deref rows
	sub	r1, r1, #1	@ decrement rows
	mov	r0, r9		@ move diff to first parameter
	bl	sdiv32		@ divide (calculate actual step)

	mov	r6, r0		@ save step

	mov	r7, #0		@ counter = 0
				@ (lo is in r5)
	
@ loop through

loop:	ldr	r1, =rows	@ load rows
	ldr	r1, [r1]	@ deref rows
	cmp	r7, r1		@ compare i to rows
	beq	end		@ if i = j, break

	mov	r0, r4		@ print number
	mov	r1, #8
	bl	printS
	
	ldr	r0, =str6	@ print newline
	bl	printf

	add	r7, r7, #1	@ i++
	add	r4, r4, r6	@ low += step
	b	loop		@ goto loop

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ cleanup

end:	
	ldmfd	sp!, {lr}
	mov	pc, lr
