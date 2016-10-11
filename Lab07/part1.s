@@ This program gives the user all prime numbers from 1 to n
	.data
str1:	.asciz	"Enter a number: "
	.align	2
str2:	.asciz	"%d"
	.align	2
str3:	.asciz	"%d\n"
	.align	2
str4:	.asciz	"Found %d primes\n"
	.align	2
n:	.word	0




isPrime:			@ Takes in an int, returns 1 if prime, 0 if not
	stmfd	sp!, {r4,r5,lr}
	mov	r4, r0		@ r0 = n
	mov	r5, #2		@ i = 2
	cmp	r4, r5		@ Compare n to 2
	movlt	r0, #0		@ If n < 2, return 0
	blt	primeEnd	@ If n < 2, end
primeLoop:
	cmp	r4, r5		@ Compare n to i
	moveq	r0, #1		@ if n = i, return 1
	beq	primeEnd	@ if n = i, end

	mov	r0, r4		@ Move n to r0
	mov	r1, r5		@ Move i to r1
	bl	udiv32		@ Divide n/i

	cmp	r1, #0		@ Compare remainder with 0
	moveq	r1, #0		@ If remainder = 0, return 0
	beq	primeEnd	@ If remainder = 0, end

	add	r5, r5, #1	@ Increment i
	b	primeLoop	@ To top of loop
	
primeEnd:
	ldmfd	sp!, {r4,r5,lr}
	mov	pc, lr



udiv32:				@ Takes in a dividend and a divisor, returns answer and remainder
	stmfd	sp!, {lr}
	cmp	r1, #0		@ If divisor == 0
	beq	quitdiv32	@ Exit immediately
	mov	r2, r1		@ Move divisor to r2
	mov	r1, r0		@ Move dividend to r1
	mov	r0, #0		@ Clear r0 to accumulate result
	mov	r3, #1		@ Set "Current" bit in r3
divstrt:
	cmp	r2, #0		@ While (msb of r2 != 1)
	blt	divloop
	cmp	r2, r1		@ && (divisor < dividend)
	lslls	r2, r2, #1	@ Shift divisor left
	lslls	r3, r3, #1	@ Shift current right
	bls	divstrt		@ End while
divloop:
	cmp	r1, r2		@ If(divisor < dividend)
	subhs	r1, r1, r2	@     Subtract divisor from dividend
	addhs	r0, r0, r3	@     Set "Current" bit in the result
	lsr	r2, r2, #1	@ Shift divisor right
	lsrs	r3, r3, #1	@ Shift current bit right into carry
	bcc	divloop
quitdiv32:
	ldmfd	sp!, {lr}
	mov	pc, lr




	.text
	.globl	main
main:	stmfd	sp!, {lr}
	ldr	r0, =str1	@ Load string to print
	bl	printf		@ Print string
	ldr	r0, =str2	@ Load string to scan
	ldr	r1, =n		@ Load memory to store n
	bl	scanf		@ Get integer from user
	ldr	r4, =n		@ i = n
	ldr	r4, [r4]	@ Deref n
	mov	r5, #1		@ n = 1
	mov	r6, #0		@ primes = 0

loop:	mov	r0, r5		@ Move n to r0
	bl	isPrime		@ Check if n is prime

	cmp	r0, #1		@ Is n prime?
	ldreq	r0, =str3	@ If prime, load print string
	moveq	r1, r5		@ If prime, load n
	addeq	r6, r6, #1	@ If prime, primes++
	beq	printf		@ If prime, print

	add	r5, r5, #1	@ n++
	cmp	r5, r4		@ Compare n to i
	ble	loop		@ If n <= i goto loop

end:	ldr	r0, =str4	@ Load print string
	mov	r1, r6		@ Load primes
	bl	printf		@ Print primes
	ldmfd	sp!, {lr}
	mov	pc, lr
