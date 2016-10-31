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
        mov     r5, r0          @ save lo into memory

	sub	r9, r5, r4	@ range = hi - lo, save to r9

	ldr	r1, =rows	@ load rows' address as second parameter
	ldr	r1, [r1]	@ deref rows
	sub	r1, r1, #1	@ decrement rows
	mov	r0, r9		@ move diff to first parameter
	bl	sdiv32		@ divide (calculate actual step)

	mov	r6, r0		@ save step

	ldr	r7, =lo		@ set low value as i
	ldr	r7, [r7]	@ deref

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ debugging print

        mov	r0, r6		@ print step
        mov     r1, #8
        bl      printS

        ldr     r0, =str6       @ print newline
        mov     r1, r7
        bl      printf
        ldr     r0, =str6       @ print newline
        mov     r1, r7
        bl      printf

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ loop through

@loop:	ldr	r0, =hi		@ load hi
@	ldr	r0, [r0]	@ deref hi
@	cmp	r7, r0		@ compare i to rows
@	bgt	end		@ if i > j, break
@
@	mov	r0, r7		@ print number
@	mov	r1, #0
@	bl	printS
@	
@	ldr	r0, =str6	@ print newline
@	mov	r1, r7
@	bl	printf
@
@	add	r7, r7, r6	@ i += step
@	b	loop		@ goto loop

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ cleanup

end:	
	ldmfd	sp!, {lr}
	mov	pc, lr
