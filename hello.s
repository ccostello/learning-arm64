.global _start
.align 2

_start: 
    ; TODO: is X5 safe?
    mov X5, #10         ; counter init
again:
    mov X0, #1          ; stdout
    adr X1, helloworld  ; string value
    mov X2, #13         ; string size
    mov X16, #4         ; syscall to write
    svc 0               ; invoke syscall

    add X5,X5,#-1       ; decrement counter
    cmp X5,0            ; are we there yet?
    bge again           ; if not, try again

    mov X0, #0          ; exit code
    mov X16, #1         ; exit syscall
    svc 0               ; invoke syscall

helloworld: .ascii "Hello World!\n"