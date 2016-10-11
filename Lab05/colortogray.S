	.data
str1:	.asciz "Height: %d\n"
	.align 2
str2:	.asciz "Width : %d\n"
	.align 2

r:	.word 54
g:	.word 184
b:	.word 18

	.global	color_to_gray
color_to_gray: @ takes in a pointer to a ppm image, returns a pointer to a new ppm image
	stmfd	sp!,{r4-r7,lr}	@ push r4-r7 to stack

	mov	r4, r0		@ save pointer to image in r4

	ldr	r1,[r4,#8]	@ save height to r1 (r4 shifted 8)
	ldr	r0,[r4,#4]	@ save width to  r0 (r4 shifted 4)
	bl allocate_grayimage	@ allocate space for gray image

	mov	r5, r0		@ save pointer to grayimage in r5

	mov	r6, #0		@ i = 0 Keep track of current width
	mov	r7, #0		@ j = 0 Keep track of current height
loop:
	@ldr	r0, =str1	@ print height
	@mov	r1, r6
	@bl	printf

	cmp	r6, #0		@ if height is 0, print width
	ldreq	r0, =str2
	moveq	r1, r7
	bleq	printf

	mov	r0, r4		@ store ptr to image in r0
	mov     r1, r7      	@ save current height to r1
        mov     r2, r6      	@ save current width  to r2
	bl	get_ptr		@ get the pointer to the colored pixel

	bl	calc_color	@ calculates color to set (pointer already in r0)

	mov	r3, r0		@ make color the 4th parameter
	mov	r0, r5		@ load pointer to grayimage in r0
        mov     r1, r7		@ save height to r1
        mov     r2, r6		@ save width  to r2
	bl	set_color	@ sets a color in gray image

	ldr     r0,[r4,#8]      @ save height to r0 (r4 shifted 8)
        ldr     r1,[r4,#4]      @ save width  to r1 (r4 shifted 4)
	add	r6, r6, #1	@ i++
	cmp	r6, r1		@ compare i to width
	addge	r7, #1		@ if i >= width, increment j
	movge	r6, #0		@ then, set i to 0
	cmp	r7, r0		@ compare j to height
	bge	end		@ if j = height, end the program	

	b	loop		@ go back to loop
end:	
	mov	r0, r5		@ return pointer to grayimage
	ldmfd	sp!,{r4-r7,lr}	@ restore r4-r7
	mov	pc,lr		@ return



get_ptr: @ takes in pointer to image, height, width, returns pointer to pixel
	stmfd	sp!,{lr}	@ push link register

	mul	r1, r1, r2	@ curr_height *= curr_width
	lsl	r2, #2		@ multiply offset by 4

	add	r0, r0, r1	@ return old pointer + offset
	ldmfd	sp!,{lr}	@ restore link register
	mov	pc, lr		@ return



get_ptr_gray: @ takes in pointer to image, height, width, returns pointer to pixel
	stmfd	sp!,{lr}	@ push link register

	mul	r1, r1, r2	@ curr_height *= curr_width
	
	add	r0, r0, r1	@ return pointer +  offset
	ldmfd	sp!,{lr}	@ restore link register
	mov	pc, lr		@ return



calc_color: @ takes in a pointer to a pixel, returns char with grayscale color
	stmfd	sp!,{lr}	@ push link register

	ldrb	r1, [r0]	@ load r into r1
	ldrb	r2, [r0,#1]	@ load g into r2
	ldrb	r3, [r0,#2]	@ load b into r3

	ldr	r0, =r		@ load red
	ldr	r0, [r0]	@ deref red
	mul	r1, r1, r0	@ r *= 54

	ldr	r0, =g		@ load green
	ldr	r0, [r0]	@ deref green
	mul	r2, r2, r0	@ g *= 184

	ldr	r0, =b		@ load blue
	ldr	r0, [r0]	@ deref blue
	mul	r3, r3, r0	@ b *= 18

	add	r1, r1, r2	@ r += g
	add	r1, r1, r3	@ r += b
	lsr	r1, r1, #8	@ total /= 256

	mov	r0, r1		@ return r (which contains grayscale color)
	ldmfd	sp!,{lr}	@ restore link register
	mov	pc, lr		@ return



set_color: @ takes in a pointer to an image, height, width, gray_color, sets the value
	stmfd	sp!,{r4-r7,lr}	@ push link register and r4-r7

	mov	r4, r0		@ move struct ptr to r4
	mov	r5, r1		@ move height to r5
	mov	r6, r2		@ move width to r6
	mov	r7, r3		@ move value to r7

	bl	get_ptr_gray	@ get pointer to pixel to modify (all necessary data already there)

	strb	r7, [r0]	@ store the value into the struct

	ldmfd	sp!,{r4-r7,lr}	@ restore link register and r4-r7
	mov	pc, lr		@ return
