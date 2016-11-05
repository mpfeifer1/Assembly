	.data
str1:	.asciz	"Here %d\n"
	.align	2

	.text
	.globl	negate_array
negate_array:	@@ Takes in a netImage pointer by reference, rows, and cols. No return value
	stmfd	sp!, {r4, r5, r6, r7, r8, lr}

	mov	r4, #0		@ r4 = i = 0
	mov	r5, #0		@ r5 = j = 0
	mov	r6, r1		@ r6 = rows
	mov	r7, r2		@ r7 = cols
	mov	r8, r0		@ r8 = pointer to image

loop01:	cmp	r4, r6		@ i == rows
	beq	end01		@ quit

	mov	r5, #0		@ j = 0
loop02:	cmp	r5, r7		@ j == cols
	beq	end02		@ quit

	ldr	r0, [r8, r4, lsl #2]	@ load row of pointers to pixels (a[i])
	ldrb	r0, [r0, r5]		@ load a[i][j]

	mov	r1, #255		@ load 255
	sub	r0, r1, r0		@ a[i][j] -= 255
	bl	saturate		@ saturate

	ldr	r1, [r8, r4, lsl #2]	@ load row of pointers to pixels (a[i])
	strb	r0, [r1, r5]		@ store a[i][j]

	add	r5, r5, #1		@ j++
	b	loop02			@ to top of loop
end02:
	add	r4, r4, #1		@ i++
	b	loop01			@ to top of loop
end01:
	ldmfd	sp!, {r4, r5, r6, r7, r8, lr}
	mov	pc, lr



        .text
        .globl  brighten_array
brighten_array:   @@ Takes in a netImage pointer by reference, rows, col, and factor. No return value
        stmfd   sp!, {r4, r5, r6, r7, r8, r9, lr}

        mov     r4, #0          @ r4 = i = 0
        mov     r5, #0          @ r5 = j = 0
        mov     r6, r1          @ r6 = rows
        mov     r7, r2          @ r7 = cols
        mov     r8, r0          @ r8 = pointer to image
	mov	r9, r3

loop03: cmp     r4, r6          @ i == rows
        beq     end03           @ quit

        mov     r5, #0          @ j = 0
loop04: cmp     r5, r7          @ j == cols
        beq     end04           @ quit

        ldr     r0, [r8, r4, lsl #2]    @ load row of pointers to pixels (a[i])
        ldrb    r0, [r0, r5]            @ load a[i][j]

        add	r0, r0, r9		@ add brightness
        bl      saturate                @ saturate

        ldr     r1, [r8, r4, lsl #2]    @ load row of pointers to pixels (a[i])
        strb    r0, [r1, r5]            @ store a[i][j]

        add     r5, r5, #1              @ j++
        b       loop04                  @ to top of loop
end04:
        add     r4, r4, #1              @ i++
        b       loop03                  @ to top of loop
end03:
        ldmfd   sp!, {r4, r5, r6, r7, r8, r9, lr}
        mov     pc, lr

