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
str8:	.asciz	"\t"
	.align	2
lo:	.asciz	"0.0"
	.align	4

hi:	.asciz	"0.0"
	.align	4

rows:	.word	0
	.align	4

step:	.asciz	"0.0"
	.align	4


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	.text
	.globl	calc
calc:	@@ Calculates the really ugly thing. takes in x in r0, returns in r0
	stmfd	sp!, {r4,r5,r6,r7,lr}

	mov	r4, r0		@ r4 = x

	mov	r1, r0		@ r1 = x
	bl	multiply	@ r0 = x^2
	mov	r5, r0		@ r5 = x^2

	mov	r1, r4		@ r1 = x
	bl	multiply	@ r0 = x^3
	mov	r6, r0		@ r6 = x^3

	mov	r0, r4		@ r0 = x
	add	r0, r0, r0	@ r0 = 2x

	sub	r6, r6, r5	@ r6 = x^3-x^2
	sub	r6, r6, r0	@ r6 = x^2-x^2-2x << Numerator

	mov	r0, r4		@ r0 = x
	mov	r1, #2		@ load 2
	lsl	r1, #16		@ shift 2 left
	sub	r0, r0, r1	@ r0 = x-2
	mov	r1, r0		@ set up 2nd parameter
	bl	multiply	@ r0 = (x-2)^2
	mov	r1, r0		@ set up 2nd parameter
	bl	multiply	@ r0 = (x-2)^4

	mov	r1, #11		@ load 11
	bl	sdiv32		@ r0 = (x-2)^4/11
	mov	r1, #3		@ load 3
	lsl	r1, #16		@ shift 3 left
	add	r1, r0, r1	@ r1 = ((x-2)^4/11)+3 << Denominator
	mov	r0, r6		@ r0 = Numerator

	bl	div

	ldmfd	sp!, {r4,r5,r6,r7,lr}
	mov	pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

multiply: @ multiply r0 and r1, return result in r0
	stmfd	sp!, {lr}

	smull	r0, r1, r0, r1	@ multiply r0 and r1, store in r1:r0

	lsr	r0, #16
	lsl	r1, #16
	orr	r0, r0, r1

	ldmfd	sp!, {lr}
	mov	pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	.global	div
div:	stmfd	sp!, {r4, lr}
	cmp	r0, #0		@ essentially, check if negative
	mov	r2, r1
	movlt	r1, #-1
	movge	r1, #0
	cmp	r2, #0
	movge	r3, #0
	movlt	r3, #-1
	mov	r4, #0

shift:	cmp	r4, #16		@ form number as r1:r0
	bge	divide
	lsls	r0, r0, #1
	lsl	r1, r1, #1
	addhs	r1, r1, #1
	add	r4, r4, #1	@ increment counter
	b	shift

divide:	bl	sdiv64		@ divide

	ldmfd	sp!, {r4, lr}
	mov	pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

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
	mov	r1, #16		@ 16 frac bits
	bl	strtoSfixed	@ convert lo to fixed
	mov	r4, r0		@ save lo into memory

        ldr     r0, =hi         @ make hi parameter 1
        mov     r1, #16		@ 16 frac bits
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

	@ bl and calculate here

	mov	r0, r4		@ print number
	mov	r1, #16
	bl	printS
	
        ldr     r0, =str8       @ print tab
        bl      printf

	mov	r0, r4		@ set number as input for calc
	bl	calc		@ calculate ugly thing

        mov     r1, #16		@ print processed number
        bl      printS

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
