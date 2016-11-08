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
	.word	0

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

	ldr	r0, =str9	@ scan rows
	ldr	r1, =rows
	bl	scanf



	ldr		r0, =lo		@ r0 = low
	vldr.f64	d8, [r0]	@ d8 = low
	ldr		r0, =hi		@ r0 = high
	vldr.f64	d9, [r0]	@ d9 = high

	vsub.f64	d10, d9, d8	@ d10 = range

	ldr		r0, =rows	@ r0 = rows
	vldr.f64	d11, [r0]	@ d11 = rows

	mov		r0, #1		@ load 1 into d12
	mov		r1, #0
	vmov		d12, r0, r1
	vcvt.f64.s32	d12, s24

	vsub.f64	d11, d11, d12	@ rows--
	
	vdiv.f64	d12, d10, d11	@ d12 = step


					@ d8 (low) is now counter
loop:	vcmp.f64	d8, d9		@ compare low and high
	vmrs		APSR_nzcv,fpscr	@ copy over flags
	bge		end		@ branch to end

	tst		sp,#4		@ print left half of table
	vmovne		r1, r2, d8
	vmoveq		r2, r3, d8
	ldr		r0, =str10
	bl		printf

	vadd.f64	d8, d8, d12	@ i += step
	b		loop		@ to top of loop
end:

	mov		r4, #0		@ r4 = i = 0

	ldmfd	sp!, {lr}
	mov	pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
