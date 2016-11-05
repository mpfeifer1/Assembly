@@ This program makes another table for the really ugly function described in str1

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
str9:	.asciz	"%lf"
	.align	2
str10:	.asciz	"%f\n"
	.align	2
str11:	.asciz	"%d\n"
	.align	2

lo:	.word	0
	.word	0
hi:	.word	0
	.word	0
rows:	.word	0

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	.text
	.globl	main
main:	stmfd	sp!, {lr}

@read in all the values
	ldr	r0, =str1	@ print program description
	bl	printf

	ldr	r0, =str2	@ print low prompt
	bl	printf

	ldr	r0, =str9	@ scan low value
	ldr	r1, =lo
	bl	scanf

	ldr	r0, =str3	@ print high prompt
	bl	printf

	ldr	r0, =str9	@ scan high value
	ldr	r1, =hi
	bl	scanf

	ldr	r0, =str5	@ print row prompt
	bl	printf

	ldr	r0, =str7	@ scan rows
	ldr	r1, =rows
	bl	scanf

/*
@print all the values
	ldr		r0, =lo		@ print low
	vldr.f64	d0, [r0]	@ load low into float register
	tst		sp,#4		@ check to see if stack is aligned
	vmovne		r1, r2, d0	@ move to r1,r2 if not aligned
	vmoveq		r2, r3, d0	@ move to r2,r3 if aligned
	ldr		r0, =str10	@ load pointer to format string
	bl		printf

	ldr		r0, =hi		@ print high
	vldr.f64	d0, [r0]	@ load high into float register
	tst		sp,#4		@ check to see if stack is aligned
	vmovne		r1, r2, d0	@ move to r1,r2 if not aligned
	vmoveq		r2, r3, d0	@ move to r2,r3 if aligned
	ldr		r0, =str10	@ load pointer to format string
	bl		printf

	ldr		r0, =str11	@ print rows
	ldr		r1, =rows
	ldr		r1, [r1]
	bl		printf
*/


	ldmfd	sp!, {lr}
	mov	pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
