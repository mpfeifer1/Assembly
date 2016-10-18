@@ This program takes in 4 sets of coins, and adds the total, calculates the average, and the estimated
@@ yearly savings

	.data
str1:	.asciz	"Enter the number of pennies, nickels, dimes and quarters for week %d: "
	.align	2
str2:	.asciz	"%d %d %d %d"
	.align 	2
str3:	.asciz	"Over four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters\n"
	.align	2
str4:	.asciz	"This comes to %d\n"
	.align	2
str5:	.asciz	"Your weekly average is %d\n"
	.align	2
str6:	.asciz	"Your estimated yearly savings is %d\n"
	.align	2

p:	.word	0
n:	.word	0
d:	.word	0
q:	.word	0


	.text

div4:	stmfd	sp!, {lr}	@@ takes in a number, returns it divided by 4

	lsr	r0, r0, #2

	ldmfd	sp!, {lr}
	mov 	pc, lr



mul13:	stmfd	sp!, {lr}	@@ Takes in a number, returns it multiplied by 13

	add	r1, r0, r0, lsl #3	@ r1 = 8r0
	add	r1, r1, r0, lsl #2	@ r1 += 4r0 (r1 is 12r0)
	add	r0, r1, r1		@ r0 += r1

	ldmfd	sp!, {lr}
	mov	pc, lr

mul1:  stmfd   sp!, {lr}       @@ Takes in a number, returns it multiplied by 1

        ldmfd   sp!, {lr}
        mov     pc, lr

mul5:  stmfd   sp!, {lr}       @@ Takes in a number, returns it multiplied by 5

	mov	r1, #0			@ r1 = 0
        add     r1, r1, r0, lsl #2      @ r1 += 4r0
        add     r0, r1, r1              @ r0 += r1

        ldmfd   sp!, {lr}
        mov     pc, lr

mul10:  stmfd   sp!, {lr}       @@ Takes in a number, returns it multiplied by 10

        add     r0, r0, r0		@ r0 *= 2
        add     r0, r0, r0, lsl #2      @ r0 += 4r0

        ldmfd   sp!, {lr}
        mov     pc, lr

mul25:  stmfd   sp!, {lr}       @@ Takes in a number, returns it multiplied by 25

        add     r1, r0, r0, lsl #4      @ r1 = 16r0
        add     r1, r1, r0, lsl #3      @ r1 += 8r0 (r1 is 24r0)
        add     r0, r1, r1              @ r0 += r1

        ldmfd   sp!, {lr}
        mov     pc, lr



	.globl	main
main:	stmfd	sp!, {lr}
	mov	r4, #0		@ pennies  = 0
	mov	r5, #0		@ nickels  = 0
	mov	r6, #0		@ dimes    = 0
	mov	r7, #0		@ quarters = 0
	mov	r8, #1		@ i = 1

loop:	ldr	r0, =str1	@ load string to print
	mov	r1, r8		@ load week to print
	bl	printf		@ print string

	ldr	r0, =str2	@ load string to scan
	ldr	r1, =p		@ load pennies location
	ldr	r2, =n		@ load nickels location
	ldr	r3, =d		@ load dimes location	
	ldr	r4, =q		@ load quarters location
	str	r4, [sp,#-4]!	@ push quarters location to stack
	bl	scanf		@ get ints
	add	sp, sp, #4	@ fix stack

	ldr	r0, =p		@ load pennies
	ldr	r0, [r0]
	add	r4, r4, r0	@ add to pennies

	ldr	r1, =n
	ldr	r1, [r1]
	add	r5, r5, r1	@ add to nickels

	ldr	r2, =d
	ldr	r2, [r2]
	add	r6, r6, r2	@ add to dimes

	ldr	r3, =q
	ldr	r3, [r3]
	add	r7, r7, r3	@ add to quarters

	add	r8, r8, #1	@ i++
	cmp	r8, #4		@ i ? 4
	ble	loop		@ i < 4 goto loop

end:	ldr	r0, =str3	@ load string to print
	mov	r1, r4		@ load pennies
	mov	r2, r5		@ load nickels
	mov	r3, r7		@ load dimes
        ldr     r4, =q          @ load quarters
        str     r4, [sp,#-4]!   @ push quarters location to stack
	bl	printf		@ print
	add	sp, sp, #4	@ fix stack
	

	ldmfd	sp!, {lr}
	mov	pc, lr
