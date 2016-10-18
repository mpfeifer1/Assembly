@@ This program makes a table for the really ugly function described in str1

	.data
str1:	.asciz	"This program will create a table for f(x) where\n     x^3-x^2-2x \nf(x)=-----------\n     (x-2)^4\n     ------- +3\n        11\n"
	.align	2
str2:	.asciz	"Enter lower bound: "
	.align	2
str3:	.asciz	"Enter upper bound: "
	.align	2
str4:	.asciz	"%d"
	.align	2
str5:	.asciz	"Enter a number of rows: "
	.align	2
str6:	.asciz	"%d\n"
	.align	2
lo:	.word	0
hi:	.word	0
rows:	.word	0
step:	.word	0

	.text
	.globl	main
main:	stmfd	sp!, {lr}

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

	ldr	r0, =str4	@ load string to scan
	ldr	r1, =rows	@ load rows
	bl	scanf		@ scan

	ldr	r4, =lo		@ load lo
	ldr	r4, [r4]	@ deref lo
	ldr	r5, =hi		@ load hi
	ldr	r5, [r5]	@ deref hi
	
	sub	r0, r5, r4	@ diff = hi - lo
	ldr	r1, =rows	@ load rows as second parameter
	ldr	r1, [r1]	@ deref rows
	bl	sdiv32		@ divide
	sub	r0, r0, #1
	mov	r6, r0		@ save result to r6

	ldr	r7, =lo		@ load low value into r7
	ldr	r7, [r7]	@ deref

loop:	ldr	r0, =hi		@ load hi
	ldr	r0, [r0]	@ deref hi
	cmp	r7, r0		@ compare i to rows
	bgt	end		@ if i > j, break

	ldr	r0, =str6
	mov	r1, r7
	bl	printf

	
	add	r7, r7, r6	@ i += step
	b	loop		@ goto loop
end:	

	ldmfd	sp!, {lr}
	mov	pc, lr
