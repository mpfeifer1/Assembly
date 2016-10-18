@@ This program takes in 4 sets of coins, and adds the total, calculates the average, and the estimated
@@ yearly savings

	.data
str1:	.asciz	"Enter the number of pennies, nickels, dimes and quarters for week %d: "
	.align	2
str2:	.asciz	"%d %d %d %d"
	.align 	2
str3:	.asciz	"\nOver four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters\n"
	.align	2
str4:	.asciz	"This comes to $%d.%d\n"
	.align	2
str5:	.asciz	"Your weekly average is $%d.%d\n"
	.align	2
str6:	.asciz	"Your estimated yearly savings is $%d.%d\n"
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

div100:	stmfd	sp!, {lr}	@@ takes in a number, returns it divided by 100
	mov	r2, r0		@ pyeatt's an idiot				
				@ The following code will calculate r2/100
				@ It will leave the quotient in r0 and the remainder in r1
				@ It will also use register r3 as a temporary variable
	ldr	r3,=0x51EB851F	@ load 1/100 shifted left by 37 bits
	smull	r0,r1,r3,r2	@ multiply (3 to 7 clock cycles)
	mov	r3,r2,asr #31	@ get sign of numerator (0 or -1)
	rsb	r0,r3,r1,asr #5	@ shift right and adjust for sign
				@ now get the modulus, if needed
	mov	r1,#100		@ move denominator to r1
	mul	r1,r1,r0	@ multiply denominator by quotient
	sub	r1,r2,r1	@ subtract that from numerator

	ldmfd	sp!, {lr}
	mov	pc, lr

mul13:	stmfd	sp!, {lr}	@@ takes in a number, returns it multiplied by 13

	mov	r1, #0			@ r1 = 0
	add	r1, r1, r0, lsl #3	@ r1 = 8r0
	add	r1, r1, r0, lsl #2	@ r1 += 4r0 (r1 is 12r0)
	add	r0, r0, r1		@ r0 += r1

	ldmfd	sp!, {lr}
	mov	pc, lr

mul5:  stmfd   sp!, {lr}       @@ takes in a number, returns it multiplied by 5

        add     r0, r0, r0, lsl #2	@ r0 += r1

        ldmfd   sp!, {lr}
        mov     pc, lr

mul10:  stmfd   sp!, {lr}       @@ takes in a number, returns it multiplied by 10

        add     r0, r0, r0		@ r0 *= 2
        add     r0, r0, r0, lsl #2      @ r0 += 4r0

        ldmfd   sp!, {lr}
        mov     pc, lr

mul25:  stmfd   sp!, {lr}       @@ takes in a number, returns it multiplied by 25

	mov	r1, #0
        add     r1, r1, r0, lsl #4      @ r1 = 16r0
        add     r1, r1, r0, lsl #3      @ r1 += 8r0 (r1 is 24r0)
        add     r0, r0, r1              @ r0 += r1

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

	ldr	r1, =p		@ load pennies location
	ldr	r2, =n		@ load nickels location
	ldr	r3, =d		@ load dimes location	
	ldr	r0, =q		@ load quarters location
	str	r0, [sp,#-4]!	@ push quarters location to stack
	ldr	r0, =str2	@ load string to scan
	bl	scanf		@ get ints
	add	sp, sp, #4	@ fix stack

	ldr	r0, =p		@ load pennies
	ldr	r0, [r0]	@ deref pennies
	add	r4, r4, r0	@ add to pennies

	ldr	r1, =n		@ load nickels
	ldr	r1, [r1]	@ deref nickels
	add	r5, r5, r1	@ add to nickels

	ldr	r2, =d		@ load dimes
	ldr	r2, [r2]	@ deref dimes
	add	r6, r6, r2	@ add to dimes

	ldr	r3, =q		@ load quarters
	ldr	r3, [r3]	@ deref quarters
	add	r7, r7, r3	@ add to quarters

	add	r8, r8, #1	@ i++
	cmp	r8, #4		@ i ? 4
	ble	loop		@ i < 4 goto loop

end:	ldr	r0, =str3	@ load string to print
	mov	r1, r4		@ load pennies
	mov	r2, r5		@ load nickels
	mov	r3, r6		@ load dimes
        str     r7, [sp,#-4]!   @ push quarters location to stack
	bl	printf		@ print
	add	sp, sp, #4	@ fix stack

				@ r4 is now total pennies
	mov	r0, r5		@ move nickels to r0
	bl	mul5		@ multiply nickels by 5
	add	r4, r4, r0	@ pennies += nickels*5

	mov	r0, r6		@ move dimes to r0
	bl	mul10		@ multiply dimes by 10
	add	r4, r4, r0	@ pennies += dimes*10

	mov	r0, r7		@ move quarters to r0
	bl	mul25		@ multiply quarters by 25
	add	r4, r4, r0	@ pennies += quarters*25

	mov	r0, r4		@ move pennies to r0
	bl	div100		@ divide pennies by 100
	mov	r2, r1		@ move pennies left to r2
	mov	r1, r0		@ move dollars to r1
	ldr	r0, =str4	@ load string to print
	bl	printf		@ print

	mov	r0, r4		@ move pennies to r0
	bl	div4		@ divide pennies by 4
	bl	div100		@ divide pennies by 100
	mov	r2, r1		@ move pennies left to r2
	mov	r1, r0		@ move dollars to r1
	ldr	r0, =str5	@ load string to print
	bl	printf		@ print
	
	mov     r0, r4          @ move pennies to r0
        bl      mul13           @ multiply pennies by 13
        bl      div100          @ divide pennies by 100
        mov     r2, r1          @ move pennies left to r2
        mov     r1, r0          @ move dollars to r1
        ldr     r0, =str5       @ load string to print
        bl      printf          @ print


	ldmfd	sp!, {lr}
	mov	pc, lr
