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
	mov	r9, r3		@ r9 = brightness

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



        .text
        .globl  sharpen_array
sharpen_array:   @@ Takes in a netImage pointer by reference, rows, col. Returns pointer to image
        stmfd   sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}

        mov     r4, #1          	@ r4 = i = 1
        mov     r5, #1          	@ r5 = j = 1
        mov     r6, r1          	@ r6 = rows
        mov     r7, r2          	@ r7 = cols
        mov     r8, r0       	   	@ r8 = a

	mov	r0, r1			@ r0 = rows
	mov	r1, r2			@ r1 = cols
	bl	allocate_pixel_array	@ make new array
	mov	r9, r0			@ r9 = tmp

	sub	r6, r6, #1		@ rows--
	sub	r7, r7, #1		@ cols--

loop05: cmp     r4, r6          	@ i == rows
        beq     end05           	@ quit

        mov     r5, #1          	@ j = 1
loop06: cmp     r5, r7          	@ j == cols
        beq     end06           	@ quit

	add	r4, r4, #1		@ i++
        ldr     r0, [r8, r4, lsl #2]    @ load row of pointers to pixels (a[i+1])
        ldrb    r0, [r0, r5]            @ load a[i+1][j]
	sub	r4, r4, #1		@ i--
	mov	r10, r0			@ total = a[i+1][j]

        sub     r4, r4, #1              @ i--
        ldr     r0, [r8, r4, lsl #2]    @ load row of pointers to pixels (a[i-1])
        ldrb    r0, [r0, r5]            @ load a[i-1][j]
        add     r4, r4, #1              @ i++
        add     r10, r10, r0            @ total += a[i-1][j]

        add     r5, r5, #1              @ j++
        ldr     r0, [r8, r4, lsl #2]    @ load row of pointers to pixels (a[i])
        ldrb    r0, [r0, r5]            @ load a[i][j+1]
        sub     r5, r5, #1              @ j--
        add     r10, r10, r0            @ total += a[i][j+1]

        sub     r5, r5, #1              @ j--
        ldr     r0, [r8, r4, lsl #2]    @ load row of pointers to pixels (a[i])
        ldrb    r0, [r0, r5]            @ load a[i][j-1]
        add     r5, r5, #1              @ j++
        add     r10, r10, r0            @ total += a[i][j-1]

	ldr     r0, [r8, r4, lsl #2]    @ load row of pointers to pixels (tmp[i])
        ldrb    r0, [r0, r5]            @ load tmp[i][j]
	add	r0, r0, r0, lsl #2	@ tmp[i][j] += 4tmp[i][j]
	sub	r0, r0, r10		@ 5tmp[i][j] -= total
        bl      saturate                @ saturate
        ldr     r1, [r9, r4, lsl #2]    @ load row of pointers to pixels (tmp[i])
        strb    r0, [r1, r5]            @ store tmp[i][j]

        add     r5, r5, #1              @ j++
        b       loop06                  @ to top of loop
end06:
        add     r4, r4, #1              @ i++
        b       loop05                  @ to top of loop
end05:
	ldr	r0, [r8, #0]		@ load a[0]
	ldrb	r0, [r0, #0]		@ load a[0][0]
	ldr	r1, [r8, #0]		@ load a[0]
	ldrb	r1, [r1, #1]		@ load a[0][1]
	ldr     r2, [r8, #4]            @ load a[1]
        ldrb    r2, [r2, #0]            @ load a[1][0]	
	add	r0, r0, r0		@ a[0][0] *= 2
	sub	r0, r0, r1		@ subtract a[0][1]
	sub	r0, r0, r2		@ subtract a[1][0]
	bl	saturate		@ saturate
        ldr     r1, [r9, #0]    	@ load row of pointers to pixels (tmp[0])
        strb    r0, [r1, #0]            @ store tmp[0][0]

	ldr	r0, [r8, #0]		@ load a[0]
	ldrb	r0, [r0, r7]		@ load a[0][cols]
	sub	r7, r7, #1		@ cols--
	ldr	r1, [r8, #0]		@ load a[0]
	ldrb	r1, [r1, r7]		@ load a[0][cols-1]
	add	r7, r7, #1		@ cols++
	ldr     r2, [r8, #4]            @ load a[1]
        ldrb    r2, [r2, r7]            @ load a[1][cols]	
	add	r0, r0, r0		@ a[0][0] *= 2
	sub	r0, r0, r1		@ subtract
	sub	r0, r0, r2		@ subtract
	bl	saturate		@ saturate
        ldr     r1, [r9, #0]    	@ load row of pointers to pixels (tmp[0])
        strb    r0, [r1, r7]            @ store tmp[0][cols]

	ldr	r0, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r0, [r0, #0]		@ load a[rows][0]
	ldr	r1, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r1, [r1, #1]		@ load a[rows][1]
	sub	r6, r6, #1		@ rows--
	ldr     r2, [r8, r6, lsl #2]    @ load a[rows-1]
        ldrb    r2, [r2, #0]            @ load a[rows-1][0]
	add	r6, r6, #1		@ rows++	
	add	r0, r0, r0		@ a[0][0] *= 2
	sub	r0, r0, r1		@ subtract
	sub	r0, r0, r2		@ subtract
	bl	saturate		@ saturate
        ldr     r1, [r9, r6, lsl #2]	@ load row of pointers to pixels (tmp[rows])
        strb    r0, [r1, #0]            @ store tmp[rows][0]

	ldr	r0, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r0, [r0, r7]		@ load a[rows][cols]
	sub	r7, r7, #1		@ cols--
	ldr	r1, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r1, [r1, r7]		@ load a[rows][cols-1]
	add	r7, r7, #1		@ cols++
	sub	r6, r6, #1		@ rows--
	ldr     r2, [r8, r6, lsl #2]    @ load a[rows-1]
        ldrb    r2, [r2, r7]            @ load a[rows-1][cols]
	add	r6, r6, #1		@ rows++	
	add	r0, r0, r0		@ a[0][0] *= 2
	sub	r0, r0, r1		@ subtract
	sub	r0, r0, r2		@ subtract
	bl	saturate		@ saturate
        ldr     r1, [r9, r6, lsl #2]	@ load row of pointers to pixels (tmp[rows])
        strb    r0, [r1, r7]            @ store tmp[rows][cols]

	mov	r4, #1			@ i = 1
loop07: cmp     r4, r6          	@ i == rows
        beq     end07           	@ quit

	ldr	r1, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r1, [r1, #0]		@ load a[i][0]
	add	r1, r1, r1, lsl #1	@ a[i][0] *= 3
	ldr	r0, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r0, [r0, #1]		@ load a[i][1]
	sub	r1, r1, r0		@ subtract
	sub	r4, r4, #1		@ i--
	ldr	r0, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r0, [r0, #0]		@ load a[i-1][0]
	sub	r1, r1, r0		@ subtract
	add	r4, r4, #2		@ i += 2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r0, [r0, #0]		@ load a[i+1][0]
	sub	r1, r1, r0		@ subtract
	sub	r4, r4, #1		@ i--
	mov	r0, r1			@ make pixel the parameter
	bl	saturate		@ saturate
	ldr	r1, [r9, r4, lsl #2]	@ load tmp[i]
	strb	r0, [r1, #0]		@ store into tmp[i][0]

	ldr	r1, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r1, [r1, r7]		@ load a[i][cols]
	add	r1, r1, r1, lsl #1	@ a[i][0] *= 3
	ldr	r0, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r0, [r0, r7]		@ load a[i][cols]
	sub	r1, r1, r0		@ subtract
	sub	r4, r4, #1		@ i--
	ldr	r0, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r0, [r0, r7]		@ load a[i-1][cols]
	sub	r1, r1, r0		@ subtract
	add	r4, r4, #2		@ i += 2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r0, [r0, r7]		@ load a[i+1][cols]
	sub	r1, r1, r0		@ subtract
	sub	r4, r4, #1		@ i--
	mov	r0, r1			@ make pixel the parameter
	bl	saturate		@ saturate
	ldr	r1, [r9, r4, lsl #2]	@ load tmp[i]
	strb	r0, [r1, r7]		@ store into tmp[i][0]

        add     r4, r4, #1              @ i++
        b       loop07                  @ to top of loop
end07:

	mov	r4, #1			@ i = 1
loop08: cmp     r4, r7          	@ i == cols
        beq     end08           	@ quit

	ldr	r1, [r8]		@ load a[0]
	ldrb	r1, [r1, r4]		@ load a[0][i]
	add	r1, r1, r1, lsl #1	@ a[0][i] *= 3
	sub	r4, r4, #1		@ i--
	ldr	r0, [r8]		@ load a[0]
	ldrb	r0, [r0, r4]		@ load a[0][i-1]
	sub	r1, r1, r0		@ subtract
	add	r4, r4, #2		@ i += 2
	ldr	r0, [r8]		@ load a[0]
	ldrb	r0, [r0, r4]		@ load a[0][i+1]
	sub	r1, r1, r0		@ subtract
	sub	r4, r4, #1		@ i--
	ldr	r0, [r8, #4]		@ load a[1]
	ldrb	r0, [r0, r4]		@ load a[1][i]
	sub	r0, r1, r0		@ subtract
	bl	saturate		@ saturate
	ldr	r1, [r9]		@ load tmp[0]
	strb	r0, [r1, r4]		@ store into tmp[0][i]

	ldr	r1, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r1, [r1, r4]		@ load a[rows][i]
	add	r1, r1, r1, lsl #1	@ a[0][i] *= 3
	sub	r4, r4, #1		@ i--
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r0, [r0, r4]		@ load a[rows][i-1]
	sub	r1, r1, r0		@ subtract
	add	r4, r4, #2		@ i += 2
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r0, [r0, r4]		@ load a[rows][i+1]
	sub	r1, r1, r0		@ subtract
	sub	r4, r4, #1		@ i--
	sub	r6, r6, #1		@ rows--
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r0, [r0, r4]		@ load a[rows-1][i]
	add	r6, r6, #1		@ rows++
	sub	r0, r1, r0		@ subtract
	bl	saturate		@ saturate
	ldr	r1, [r9, r6, lsl #2]	@ load tmp[rows]
	strb	r0, [r1, r4]		@ store into tmp[rows][i]


        add     r4, r4, #1              @ i++
        b       loop08                  @ to top of loop
end08:

	mov	r0, r8			@ delete a
	mov	r1, r6
	add	r1, r1, #1
	bl	free_pixel_array

	mov	r0, r9			@ return tmp
        ldmfd   sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
        mov     pc, lr


