//: add two user inputted numbers

.section .text

.global _start

// assume r0(first argument in arm convention) is going to point to buffer to write to
// then r1 is going to be number of bytes to read
read_user_input
    push {lr}
    push {r4 r11}
    push {r1}
    push {r0}
    mov r7, #0x3
    mov r0, #0x0
    pop {r1}
    pop {r2}
    svc 0x0
    pop {r4 r11}
    pop {pc}

// when a number is wrote into memory or numbers in general
// the way counting systems work is you have a number it is that number times ten to the power of zero
// so we have to take our string, have a pointer to that string that is at the end of the string
// by finding a /n or /0 then have a counter variable
// then have another counter that checks how far into the string we are
// checks to the left by one and multiplus it by ten to the power of 0

// given a pointer to the front of the string and then figure out where the back is and add it to the counter
// r0 is a pointer to a string of ascii numbers assuming good input
my_atoi:
    push {lr}
    push {r4 r11}
    mov r2, #0x0 // our string length counter
    mov r5, #0x0 // end state counter value
    mov r6, #1
    mov r7, #10

_string_length_loop
    ldrb r8, [r0]
    cmp r8, #0xa
    beq _count
    add r0, r0, #1
    add r2, r2, #1
    b _string_length_loop

// parsing the number and printing the first number 

_count
    sub. r0, r0 #1
    ldrb r8, [r0] // the first number in the string
    sub r8, r8 #0x30
    mul r4, r8, r6 // current place times number
    mov r8, r4
    mul r4, r6, r7 // incrementing placeholder
    mov r6, r4
    add r5, r5, r8 // add current number to counter
    sub r2, r2 #1 // decrement length and check for end 
    cmp r2, #0x0
    beq _leave
    b _count

_leave:
    mov r0, r5

    pop {r4 r11}
    pop{pc}

int_to_string:
    push {lr}
    push {r4 r11}
    mov r2, #0x0 // length counter
    mov r3, #1000 // current place
    mov r7, #10 // place divisor

_loop:
    mov r4, 0x0
    udiv r4, r0, r3
    add r4, r4, #0x30 // convert result to ascii

    ldr r5, =sum // store ascii
    add r5, r5, r2
    strb r4, [r5]
    add r2, r2, #1
// removes the place the number comes from
// continues to print the right number
    sub r4, r4, #0x30
    mul r6, r4, r3
    sub r0, r0, r6
    
    udiv r6, r3, r7
    mov r3, r6
    cmp r3, #0
    beq _leave_int
    b _loop

_leave_int:
    mov r4, 0xa
    ldr r5, #sum
    add r5, r5, r2
    add r5, r5 #1
    strb r4, [r5]
    pop {r4 r11}
    pop {pc}

display:
    push {lr}
    push {r4 r11}

    mov r7, #0x4
    mov r0, #0x1
    ldr r1, =sum
    mov r2, #0x1
    svc 0x0

    pop{r4 r11}
    pop {pc}

_start:

    // read user input
    ldr r0 =first
    ldr r1, =#0x6
    bl read_user_input

    ldr r0 =second
    ldr r1, =#0x6
    bl read_user_input

    // convert that input into a number
    ldr r0, =first
    bl my_atoi
    mov r4, r0

    ldr r0, =second
    bl my_atoi
    mov r5, r0


    // add the two inputs
    add r0, r4, r5
    bl int_to_string

    // then display
    bl display

    mov r0, #0x0
    mov r7, #0x1
    mov r0, #13
    svc 0x0

.section .data

first:
    .skip 8

second:
    .skip 8

sum: 
    .skip 8