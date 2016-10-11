@@ This program implements enqueue and dequeue for the c code

	.data
MAX:	.word	52 		@ Maximim queue size

	.equ array,	0	@ Offset to beginning of array
	.equ front,	208	@ Offset to frontindex
	.equ end,	212	@ Offset to endindex
	.equ items,	216	@ Offset to num of items

str1:	.asciz	"Enqued %d\n"
	.align 2
str2:	.asciz	"Dequed %d\n"
	.align 2

	.text

	.global _ZN5queue5enqueEi
_ZN5queue5enqueEi:
	stmfd	sp!, {r4-r6,lr}
	mov	r4, r0		@ Save pointer to queue into r4
	mov	r5, r1		@ Save item in r5
	bl	_ZN5queue6isfullEv	@ Check if queue is full (parameters already in place)
	cmp	r0, #1		@ Check if queue is full
	moveq	r0, #0		@ If full, return 0
	beq	endEnque	@ Go to end

	mov	r0, r4		@ Put pointer to queue in temp storage
	ldr	r6, [r0,#end]	@ load end value
	lsl	r6, r6, #2
	str	r1, [r0,r6]	@ store item into queue			@@@@@@@@@@@@@@@
	
	mov	r0, r4		@ Put pointer to queue in temp storage
	ldr	r2, [r0,#end]	@ Put pointer to endindex in temp storage
	add	r2, r2, #1	@ Add one to endindex
	str	r2, [r0,#end]	@ Store new value of endindex into memory
	ldr	r3, =MAX	@ Store pointer to MAX in r3
	ldr	r3, [r3]	@ Deref MAX
	cmp	r2, r3		@ Compare endindex to MAX
	mov	r3, #0		@ Load 0
	strge	r3, [r0,#end]	@ If endindex >= MAX, endindex = 0
	
	ldr	r2, [r0,#items]	@ Load nitems
	add	r2, r2, #1	@ Increment nitems
	str	r2, [r0,#items]	@ Store nitems back
	mov	r0, #1		@ Return 1
endEnque:
	ldmfd	sp!, {r4-r6,lr}
	mov 	pc, lr



	.global _ZN5queue5dequeERi
_ZN5queue5dequeERi:
	stmfd	sp!, {r4-r6,lr}
	mov	r4, r0		@ Save pointer to queue into r4
	bl	_ZN5queue7isemptyEv	@ Check if queue is empty (parameters already in place)
	cmp	r0, #1		@ Check if queue is full
	moveq	r0, #0		@ If empty, return 0
	beq	endDeque	@ Go to end

	mov	r0, r4		@ Put pointer to queue in temp storage
	
	mov	r0, r4		@ Put pointer to queue in temp storage
	ldr	r2, [r0,#front]	@ Put pointer to frontindex in temp storage
	lsl	r2, r2, #2
	ldr	r5, [r0,r2]	@ Load item into r5                  		@@@@@@@@@@@@@@@
	ldr	r2, [r0,#front]
	add	r2, r2, #1	@ Add one to frontindex
	str	r2, [r0,#front]	@ Store new value of frontindex into memory

	ldr	r3, =MAX	@ Store pointer to MAX in r3
	ldr	r3, [r3]	@ Deref MAX
	cmp	r2, r3		@ Compare frontindex to MAX
	mov	r3, #0		@ Load 0
	strge	r3, [r0,#front]	@ If frontindex >= MAX, frontindex = 0
	
	ldr	r2, [r0,#items]	@ Load nitems
	sub	r2, r2, #1	@ Decrement nitems
	str	r2, [r0,#items]	@ Store nitems back
	mov	r0, r5		@ Return item

endDeque:
	ldmfd	sp!, {r4-r6,lr}
	mov 	pc, lr
