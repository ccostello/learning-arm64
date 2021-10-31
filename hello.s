; TODO:
; - Print the value of the counter with each loop

.global _start
.align 2

_start:
    mov X5, #3          ; counter init
again:
    ; Write "Hello world" to stdout:
    mov X0, #1          ; stdout
    adr X1, helloworld  ; string value
    mov X2, #13         ; string size
    mov X16, #4         ; syscall to write
    svc 0               ; invoke syscall

    ; Repeat, for three total times:
    add X5,X5,#-1       ; decrement counter
    cmp X5,1            ; are we there yet?
    bge again           ; if not, try again

    ; Lower case "Hello world" and store it in the stack:
    adr x28, helloworld ; address of helloworld in x28
    ldp x0, x1, [x28]   ; put helloworld into x0 and x1 64-bit registers
    ; set register x2 to contain 0x20, repeated for as many characters
    ; as it contains. 0x20 is 0b100000, which is the bit we need to set
    ; to turn any upper case letters to lower case. (lower case letters
    ; already have that bit set, so they don't change with this operation.)
    mov x2, #0x2020202020202020
    orr x0, x0, x2      ; lowercase "Hello Wo". No need to lowercase the
                        ; contents of x1.

    ; Write it all back to the stack pointer, allocating 16 bytes for it
    ; instead of 13 because the stack pointer must be 8-byte aligned. (We
    ; also take advantage of this assumption that we'll need 16 bytes of
    ; stack space when we use two 64-bit registers to store and manipulate
    ; the string.)
    stp x0, x1, [sp, #-16]!

    ; Write the newly lowercased "hello world!" to stdout
    mov X0, #1          ; stdout
    mov X1, sp          ; string value
    mov X2, #13         ; string size
    mov X16, #4         ; syscall to write
    svc 0    

    ; Exit the program
    mov X0, #0          ; exit code
    mov X16, #1         ; exit syscall
    svc 0               ; invoke syscall

helloworld: .ascii "Hello World!\n"
