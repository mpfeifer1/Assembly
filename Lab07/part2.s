@@ This program takes in 4 sets of coins, and adds the total, calculates the average, and the estimated
@@ yearly savings

	.data
str1:	.asciz	"Enter the number of pennies, nickels, dimes and quarters for week %d: "
	.align	2
str2:	.asciz	"%d %d %d %d"
	.align 2
str3:	.asciz	"Over four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters"
	.align	2


	.text
	.globl	main
main:	stmfd	sp!, {lr}
	mov	r4, #0		@ pennies  = 0
	mov	r5, #0		@ nickels  = 0
	mov	r6, #0		@ dimes    = 0
	mov	r7, #0		@ quarters = 0
	mov	r8, #0		@ i = 0
loop:	ldr	r0, =str1	@ load string to print
	bl	scanf		@ print string
	ldr	r0, =str2	@ load string to scan
	bl	scanf		@ get ints
	
	add	r4, r4, r0	@ add to pennies
	add	r5, r5, r1	@ add to nickels
	add	r6, r6, r2	@ add to dimes
	add	r7, r7, r3	@ add to quarters

	add	r8, r8, #1	@ i++
	cmp	r8, #3		@ i ? 3
	ble	loop		@ i < 3 goto loop

	mov	r0, =str3	@ load string to print
end:	ldmfd	sp!, {lr}
	mov	pc, lr
