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





        .text
        .globl  smooth_array
smooth_array:   @@ Takes in a netImage pointer by reference, rows, col. Returns pointer to image
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


loop09:	cmp	r4, r6		@ i == rows
	beq	end09		@ quit

	mov	r5, #1		@ j = 1
loop10:	cmp	r5, r7		@ j == cols
	beq	end10		@ quit

	ldr	r2, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r2, [r2, r5]		@ load a[i][j]
	lsl	r2, r2, #2		@ a[i][j] *= 4

	sub	r4, r4, #1		@ i--
	ldr	r1, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r1, [r1, r5]		@ load a[i-1][j]
	add	r4, r4, #2		@ i+=2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r0, [r0, r5]		@ load a[i+1][j]
	add	r1, r1, r0		@ add in
	sub	r4, r4, #1		@ i--
	sub	r5, r5, #1		@ j--
	ldr	r0, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r0, [r0, r5]		@ load a[i][j-1]
	add	r1, r1, r0		@ add in
	add	r5, r5, #2		@ j+=2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r0, [r0, r5]		@ load a[i][j+1]
	sub	r5, r5, #1		@ j--
	add	r1, r1, r0		@ add in

	lsl	r1, r1, #1		@ multiply by 2
	add	r2, r2, r1		@ add to total

	sub	r4, r4, #1		@ i--
	sub	r5, r5, #1		@ j--
	ldr	r1, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r1, [r1, r5]		@ load a[i-1][j-1]
	add	r4, r4, #2		@ i+=2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r0, [r0, r5]		@ load a[i+1][j-1]
	add	r1, r1, r0		@ add in
	add	r5, r5, #2		@ j+=2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r0, [r0, r5]		@ load a[i+1][j+1]
	add	r1, r1, r0		@ add in
	sub	r4, r4, #2		@ i-=2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r0, [r0, r5]		@ load a[i-1][j+1]
	add	r4, r4, #1		@ i++
	sub	r5, r5, #1		@ j--
	add	r1, r1, r0		@ add in

	add	r0, r2, r1		@ add to total
	lsr	r0, r0, #4		@ divide by sixteen
	bl	saturate		@ saturate
	ldr	r1, [r9, r4, lsl #2]	@ load tmp[i]
	strb	r0, [r1, r5]		@ store into tmp[i][j]

	add	r5, r5, #1		@ j++
	b	loop10			@ to top of loop
end10:
	add	r4, r4, #1		@ i++
	b	loop09			@ to top of loop
end09:

	ldr	r2, [r8, #0]		@ load a[0]
	ldrb	r2, [r2, #0]		@ load a[0][0]
	lsl	r2, r2, #2		@ multiply by 4
	ldr	r1, [r8, #4]		@ load a[1]
	ldrb	r1, [r1, #0]		@ load a[1][0]
	ldr	r0, [r8, #0]		@ load a[0]
	ldrb	r0, [r0, #1]		@ load a[0][1]
	add	r1, r1, r0		@ add up
	lsl	r1, r1, #1		@ multiply by 2
	add	r2, r2, r1		@ add up
	ldr	r0, [r8, #4]		@ load a[1]
	ldrb	r0, [r0, #1]		@ load a[1][1]
	add	r0, r2, r0		@ add up
	bl	divByNine		@ divide by 9
	ldr	r1, [r9, #0]		@ load tmp[0]
	strb	r0, [r1, #0]		@ store into tmp[0][0]

	ldr	r2, [r8, #0]		@ load a[0]
	ldrb	r2, [r2, r7]		@ load a[0][cols]
	lsl	r2, r2, #2		@ multiply by 4
	ldr	r1, [r8, #4]		@ load a[1]
	ldrb	r1, [r1, r7]		@ load a[1][cols]
	sub	r7, r7, #1		@ cols--
	ldr	r0, [r8, #0]		@ load a[0]
	ldrb	r0, [r0, r7]		@ load a[0][cols-1]
	add	r1, r1, r0		@ add up
	lsl	r1, r1, #1		@ multiply by 2
	add	r2, r2, r1		@ add up
	ldr	r0, [r8, #4]		@ load a[1]
	ldrb	r0, [r0, r7]		@ load a[1][cols-1]
	add	r7, r7, #1		@ cols++
	add	r0, r2, r0		@ add up
	bl	divByNine		@ divide by 9
	ldr	r1, [r9, #0]		@ load tmp[0]
	strb	r0, [r1, r7]		@ store into tmp[0][cols]

	ldr	r2, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r2, [r2, #0]		@ load a[rows][0]
	lsl	r2, r2, #2		@ multiply by 4
	ldr	r1, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r1, [r1, #1]		@ load a[rows][1]
	sub	r6, r6, #1		@ rows--
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r0, [r0, #0]		@ load a[rows-1][0]
	add	r1, r1, r0		@ add up
	lsl	r1, r1, #1		@ multiply by 2
	add	r2, r2, r1		@ add up
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r0, [r0, #1]		@ load a[rows-1][1]
	add	r6, r6, #1		@ rows++
	add	r0, r2, r0		@ add up
	bl	divByNine		@ divide by 9
	ldr	r1, [r9, r6, lsl #2]	@ load tmp[rows]
	strb	r0, [r1, #0]		@ store into tmp[rows][0]

	ldr	r2, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r2, [r2, r7]		@ load a[rows][cols]
	lsl	r2, r2, #2		@ multiply by 4
	sub	r6, r6, #1		@ rows--
	ldr	r1, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r1, [r1, r7]		@ load a[rows-1][cols]
	add	r6, r6, #1		@ rows++
	sub	r7, r7, #1		@ cols--
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r0, [r0, r7]		@ load a[rows][cols-1]
	add	r1, r1, r0		@ add up
	lsl	r1, r1, #1		@ multiply by 2
	add	r2, r2, r1		@ add up
	sub	r6, r6, #1		@ rows--
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r0, [r0, r7]		@ load a[rows-1][cols-1]
	add	r6, r6, #1		@ rows++
	add	r7, r7, #1		@ cols++
	add	r0, r2, r0		@ add up
	bl	divByNine		@ divide by 9
	ldr	r1, [r9, r6, lsl #2]	@ load tmp[rows]
	strb	r0, [r1, r7]		@ store into tmp[rows][cols]

	mov	r4, #1			@ i = 1
loop11: cmp     r4, r6          	@ i == rows
        beq     end11           	@ quit

	ldr	r3, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r3, [r3, #0]		@ load a[i][0]
	lsl	r3, r3, #2		@ multiply by 4
	sub	r4, r4, #1		@ i--
	ldr	r2, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r2, [r2, #0]		@ load a[i-1][0]
	add	r4, r4, #1		@ i++
	ldr	r1, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r1, [r1, #1]		@ load a[i][1]
	add	r2, r2, r1		@ add up
	add	r4, r4, #1		@ i++
	ldr	r1, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r1, [r1, #0]		@ load a[i+1][0]
	add	r2, r2, r1		@ add up
	lsl	r2, r2, #1		@ multiply by 2
	add	r3, r3, r2		@ add up
	ldr	r0, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r0, [r0, #1]		@ load a[i+1][1]
	add	r3, r3, r0		@ add up
	sub	r4, r4, #2		@ i-=2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r0, [r0, #1]		@ load a[i-1][1]
	add	r4, r4, #1		@ i++
	add	r0, r3, r0		@ add up
	bl	divByTwelve		@ divide by 9
	ldr	r1, [r9, r4, lsl #2]	@ load tmp[i]
	strb	r0, [r1, #0]		@ store into tmp[i][0]

	ldr	r3, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r3, [r3, r7]		@ load a[i][cols]
	lsl	r3, r3, #2		@ multiply by 4
	sub	r4, r4, #1		@ i--
	ldr	r2, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r2, [r2, r7]		@ load a[i-1][cols]
	sub	r7, r7, #1		@ cols--
	add	r4, r4, #1		@ i++
	ldr	r1, [r8, r4, lsl #2]	@ load a[i]
	ldrb	r1, [r1, r7]		@ load a[i][cols-1]
	add	r2, r2, r1		@ add up
	add	r7, r7, #1		@ cols++
	add	r4, r4, #1		@ i++
	ldr	r1, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r1, [r1, r7]		@ load a[i+1][cols]
	add	r2, r2, r1		@ add up
	lsl	r2, r2, #1		@ multiply by 2
	add	r3, r3, r2		@ add up
	sub	r7, r7, #1		@ cols--
	ldr	r0, [r8, r4, lsl #2]	@ load a[i+1]
	ldrb	r0, [r0, r7]		@ load a[i+1][cols-1]
	add	r3, r3, r0		@ add up
	sub	r4, r4, #2		@ i-=2
	ldr	r0, [r8, r4, lsl #2]	@ load a[i-1]
	ldrb	r0, [r0, #1]		@ load a[i-1][cols-1]
	add	r7, r7, #1		@ cols++
	add	r4, r4, #1		@ i++
	add	r0, r3, r0		@ add up
	bl	divByTwelve		@ divide by 9
	ldr	r1, [r9, r4, lsl #2]	@ load tmp[i]
	strb	r0, [r1, r7]		@ store into tmp[i][cols]

        add     r4, r4, #1              @ i++
        b       loop11                  @ to top of loop
end11:

	mov	r4, #1			@ i = 1
loop12: cmp     r4, r7          	@ i == cols
        beq     end12           	@ quit

	ldr	r3, [r8, #0]		@ load a[0]
	ldrb	r3, [r3, r4]		@ load a[0][i]
	lsl	r3, r3, #2		@ multiply by 4
	sub	r4, r4, #1		@ i--
	ldr	r2, [r8, #0]		@ load a[0]
	ldrb	r2, [r2, r4]		@ load a[0][i-1]
	add	r4, r4, #1		@ i++
	ldr	r1, [r8, #4]		@ load a[1]
	ldrb	r1, [r1, r4]		@ load a[1][i]
	add	r2, r2, r1		@ add up
	add	r4, r4, #1		@ i++
	ldr	r1, [r8, #0]		@ load a[0]
	ldrb	r1, [r1, r4]		@ load a[0][i+1]
	add	r2, r2, r1		@ add up
	lsl	r2, r2, #1		@ multiply by 2
	add	r3, r3, r2		@ add up
	ldr	r0, [r8, #4]		@ load a[1]
	ldrb	r0, [r0, r4]		@ load a[1][i+1]
	add	r3, r3, r0		@ add up
	sub	r4, r4, #2		@ i-=2
	ldr	r0, [r8, #4]		@ load a[1]
	ldrb	r0, [r0, r4]		@ load a[1][i-1]
	add	r4, r4, #1		@ i++
	add	r0, r3, r0		@ add up
	bl	divByTwelve		@ divide by 9
	ldr	r1, [r9, #0]		@ load tmp[0]
	strb	r0, [r1, r4]		@ store into tmp[0][i]

	ldr	r3, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r3, [r3, r4]		@ load a[rows][i]
	lsl	r3, r3, #2		@ multiply by 4
	sub	r4, r4, #1		@ i--
	ldr	r2, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r2, [r2, r4]		@ load a[rows][i-1]
	add	r4, r4, #1		@ i++
	sub	r6, r6, #1		@ rows--
	ldr	r1, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r1, [r1, r4]		@ load a[rows-1][i]
	add	r6, r6, #1		@ rows++
	add	r2, r2, r1		@ add up
	add	r4, r4, #1		@ i++
	ldr	r1, [r8, r6, lsl #2]	@ load a[rows]
	ldrb	r1, [r1, r4]		@ load a[rows][i+1]
	add	r2, r2, r1		@ add up
	lsl	r2, r2, #1		@ multiply by 2
	add	r3, r3, r2		@ add up
	sub	r6, r6, #1		@ rows--
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r0, [r0, r4]		@ load a[rows-1][i+1]
	add	r3, r3, r0		@ add up
	sub	r4, r4, #2		@ i-=2
	ldr	r0, [r8, r6, lsl #2]	@ load a[rows-1]
	ldrb	r0, [r0, r4]		@ load a[rows-1][i-1]
	add	r6, r6, #1		@ rows++
	add	r4, r4, #1		@ i++
	add	r0, r3, r0		@ add up
	bl	divByTwelve		@ divide by 9
	ldr	r1, [r9, r6, lsl #2]	@ load tmp[rows]
	strb	r0, [r1, r4]		@ store into tmp[rows][i]

        add     r4, r4, #1              @ i++
        b       loop12                  @ to top of loop
end12:

	mov	r0, r8			@ delete a
	mov	r1, r6
	add	r1, r1, #1
	bl	free_pixel_array

	mov	r0, r9			@ return modified image
        ldmfd   sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
        mov     pc, lr





        .text
        .globl  gray_array
gray_array:	@@ Takes in r, g, b, rows, and cols in 1, 2, 3, and sp, returns funky return value
        stmfd   sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}

	mov	r4, #0			@ r4 = i = 0
	mov	r5, #0			@ r5 = j = 0
	ldr	r6, [sp, #36]		@ r6 = rows
	ldr	r7, [sp, #40]		@ r7 = cols
	mov	r8, r1			@ r8 = r
	mov	r9, r2			@ r9 = g
	mov	r10, r3			@ r10 = b

	mov	r2, #0			@ load 0
	mov	r1, #255		@ load 255
	sub	sp, sp, #12		@ move stack pointer
	str	r1, [sp, #0]		@ push 255 to stack
	str	r2, [sp, #4]		@ push 0 to stack
	str	r0, [sp, #8]		@ push struct to stack

	mov	r0, r6			@ r0 = rows
	mov	r1, r7			@ r1 = cols
	bl	allocate_pixel_array	@ make new array
	mov	r11, r0			@ r11 = grayimage

loop13: cmp     r4, r6          	@ i == rows
        beq     end13           	@ quit

        mov     r5, #0          	@ j = 0
loop14: cmp     r5, r7          	@ j == cols
        beq     end14           	@ quit

	ldr	r1, [r8, r4, lsl #2]	@ load r[i][j]
	ldrb	r1, [r1, r5]		@ load r[i][j]
	lsl	r0, r1, #5		@ r0 = 32r[i][j]
	add	r0, r0, r1, lsl #4	@ r0 = 48r[i][j]
	add	r0, r0, r1, lsl #2	@ r0 = 52[i][j]
	add	r0, r0, r1, lsl #1	@ r0 = 54[i][j]
	mov	r1, r0			@ move to correct register

	ldr	r2, [r9, r4, lsl #2]	@ load g[i][j]
	ldrb	r2, [r2, r5]		@ load g[i][j]
	lsl	r0, r2, #7		@ r0 = 128g[i][j]
	add	r0, r0, r2, lsl #5	@ r0 = 160g[i][j]
	add	r0, r0, r2, lsl #4	@ r0 = 176g[i][j]
	add	r0, r0, r2, lsl #3	@ r0 = 184g[i][j]
	mov	r2, r0			@ move to correct register

	ldr	r3, [r10, r4, lsl #2]	@ load b[i][j]
	ldrb	r3, [r3, r5]		@ load b[i][j]
	lsl	r0, r3, #4		@ r0 = 16b[i][j]
	add	r0, r0, r3, lsl #1	@ r0 = 18b[i][j]
	mov	r3, r0			@ move to correct register

	add	r0, r1, r2		@ r+g
	add	r0, r0, r3		@ r+g+b
	add	r0, r0, #128		@ r+g+b+128
	lsr	r0, #8			@ divide by 256
	bl	saturate		@ saturate
	ldr	r1, [r11, r4, lsl #2]	@ load gray[i]
	strb	r0, [r1, r5]		@ store into gray[i][j]

	ldr	r2, [sp, #0]		@ get min from stack
	ldr	r3, [sp, #4]		@ get max from stack
	cmp	r0, r2			@ compare value to min
	strlt	r0, [sp, #0]		@ if less, put on stack
	cmp	r0, r3			@ compare value to max
	strgt	r0, [sp, #4]		@ if greater, put on stack

        add     r5, r5, #1              @ j++
        b       loop14                  @ to top of loop
end14:
        add     r4, r4, #1              @ i++
        b       loop13                  @ to top of loop
end13:

	ldr	r0, [sp, #8]		@ r0 = struct
	ldr	r1, [sp, #0]		@ r1 = min
	ldr	r2, [sp, #4]		@ r2 = max
	add	sp, sp, #12		@ fix stack pointer

	lsl	r2, #8			@ shift max left
	orr	r1, r2, r1		@ or max and min

	str	r1, [r0]		@ store maxmin in struct
	str	r11, [r0, #4]		@ store image in struct

        ldmfd   sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
        mov     pc, lr





	.text
	.global contrastImage
contrastImage:	@@ takes in a netimage, doesn't return anything
	@@ just FYI, there's a weird off-by-one error somewhere that makes diff say the files are
	@@ different despite looking exactly the same
	stmfd	sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}

	mov	r4, r0			@ r4 = image
	bl	grayscaleImage		@ r0 = values
	mov	r5, r0			@ r5 = values

	lsr	r6, r5, #8		@ r6 = max
	mov	r0, #255		@ r0 = 225
	and	r7, r5, r0		@ r7 = min

	mov		r0, #1
	cmp		r6, r7
	vmoveq.f32	s16, r0		@ scale = 1
	vcvt.f32.s32	s16, s16

	movne		r8, #255	@ scale = 255
	beq		point

	sub			r9, r6, r7	@ r9 = max - min
	vmov			s16, r8		@ s0 = 255
	vcvt.f32.s32		s16, s16	@ convert to float
	vmov			s18, r9		@ s2 = max - min
	vcvt.f32.s32		s18, s18	@ convert
	vdiv.f32		s16, s16, s18	@ scale = 255 / (max - min)	

point:
	mov	r8, #0		@ i = 0
	mov	r9, #0		@ j = 0
	
	ldr	r10, [r4, #12]	@ r10 = rows
	ldr	r11, [r4, #16]	@ r11 = cols
	ldr	r6, [r4, #20]	@ r6 = gray
	
loop15:
	cmp	r8, r10
	bge	end15

loop16:
	cmp	r9, r11
	bge	end16

	ldr	r0, [r6, r8, lsl #2]
	ldrb	r0, [r0, r9]		@ this should be image->gray.i[i][j]
	sub	r0, r0, r7		@ r0 = image->gray.i[i][j] - min

	vmov		s18, r0		@ move r0 into floating point
	vcvt.f32.s32	s18, s18	@ convert
	vmul.f32	s20, s18, s16	@ s4 = scale * (image->gray.i[i][j] - min)

	mov		r1, #1		@ load 1
	vmov		s22, r1		@ s6 = 1
	vcvt.f32.s32	s22, s22	@ convert
	mov		r1, #2		@ load 2
	vmov		s24, r1		@ s8 = 2
	vcvt.f32.s32	s24, s24	@ convert

	vdiv.f32	s22, s22, s24	@ s6 = 0.5
	vadd.f32	s20, s20, s22	@ s4 = scale * (image->gray.i[i][j] - min) + 0.5
	vcvt.s32.f32	s20, s20	@ convert
	vmov		r0, s20		@ r0 = that

	bl	saturate		@ saturate

	ldr	r1, [r6, r8, lsl #2]	@ load gray.i[i]
	strb	r0, [r1, r9]		@ this should store the saturated pixel in gray.i[i][j]

	add	r9, r9, #1		@ j++
	b	loop16			@ to top
end16:
	mov	r9, #0			@ j = 0
	add	r8, r8, #1		@ i++
	b	loop15			@ to top
end15:
	ldmfd	sp!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
	mov	pc, lr






	.text
	.globl divByNine
divByNine:
	ldr	r1, =0x71C71C72
	smull	r0, r1, r0, r1
	lsr	r0, r1, #2
	mov	pc, lr





	.text
	.globl divByTwelve
divByTwelve:
	ldr	r1, =0x55555556
	smull	r0, r1, r0, r1
	lsr	r0, r1, #2
	mov	pc, lr
