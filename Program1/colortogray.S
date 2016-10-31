@ This file takes in a .ppm image, and takes in each individual pixel, converts
@ it to grayscale, and returns a new image with the gray pixels


    .equ p_red,    0     @offset to the red value
    .equ p_green,    1     @offset to the green value
    .equ p_blue,     2     @offset to the blue value

    @@image
    .equ i_pixels,    0     @offset to number of rows
    .equ i_cols,    4     @offset to number of columns
    .equ i_rows,    8     @offset to pointer to image data

    .global    color_to_gray
color_to_gray:
    /* Fill in the code to allocate a new grayimage, then convert
       each pixel from the given rgbimage from color to grayscale,
    and store it in the grayimage. */
    stmfd    sp!,{r4,r5,r6,r7,r8,r9,r11,lr}
    ldr    r4,[r0,#i_rows]     @load the numnber of rows in the image
    ldr    r5,[r0,#i_cols]     @load the number of columns in the image
    ldr    r6,[r0,#i_pixels]       @load the offset to pointer to image data
    mov     r1,r4
    mov    r0,r5            @mov the number of columns into r0
    bl    allocate_grayimage    @allocate the new image
    mov     r11,r0            @save the pointer to the struct
    ldr    r10,[r11]        @dereference the array
    mov    r1,r4            @put the rows back into r1
    mov    r2,r5            @put the cols back int r2
    mov    r3,r6            @put the number of pixels back into r3
   

    mov     r5,#0            @load a counter i into r5

loop1:    cmp    r5,r1            @compare i to the number of rows
    bge    endi            @branch to end if greater than or equal to
    mov    r6,#0            @reset the j counter
loop2:    cmp    r6,r2            @compare j to the number of cols
    bge    endj            @brance to endj if greater than or equal to

    @@accesspixel
    ldr    r4,[r3,r5, lsl#2]    @load the row
    add    r7,r6,r6,lsl#1        @calculate the column
    add    r4,r7            @get to the specific column in the row
    ldrb     r7,[r4, #p_red]        @load value of red
    ldrb    r8,[r4, #p_green]     @load value of green
    ldrb    r9,[r4, #p_blue]     @load value of blue

    @@convertpixel       
    mov    r4,#54            @move the constant 54 into r4
    mul    r7,r7,r4        @multiply the red by 54
    mov    r4,#184            @move the constant 184 into r4
    mul    r8,r8,r4        @multiply the green by 184
    mov    r4,#18            @move the constant 18 into r4
    mul    r9,r9,r4        @muliply the blue by 18
    add    r7,r7,r8        @add the red and green
    add    r7,r7,r9        @and the red and green to blue
    lsr    r7,r7,#8        @divide by 256

    @@storepixel
    ldr    r4,[r10,r5,lsl #2]    @load the row
    add    r4,r4,r6        @calculate the position
    strb    r7,[r4]            @store the value into r4
    add    r6,r6,#1        @increment the j counter
    b    loop2            @loop back to loop2
   
endj:    add    r5,r5,#1        @increment the i counter
    b    loop1            @loop back to loop1

   
endi:    mov    r0,r11            @move the pointer of the struct into r0
    ldmfd    sp!,{r4,r5,r6,r7,r8,r9,r11,lr}    @restore the registers
    mov    pc,lr            @return

