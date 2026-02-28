.data
    fname: .asciz "image.bmp" #the name of the file
    .include "image.h" #include the header
    encodedMessage: .skip 3072

.bss
    buffer: .skip 3072

.text
    inputString: .asciz "The quick brown fox jumps over the lazy dog"
    .include "generateInitialBarcode.s"
    .include "encodeRLE.s"
    .include "executeXOR.s"

.global main

main:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    #create file
    movq $85, %rax                  #system call - create the file
    movq $fname, %rdi               #the file name
    movq $511, %rsi                 #the mode
    syscall                        

    #save the file description in a callee-saved register
    pushq %r14
    pushq %r14
    movq %rax, %r14

    #insert headline to file
    movq $1, %rax                    #system call - write in the file
    movq %r14, %rdi                  #the file description
    movq $file_header, %rsi          #the address of buffer to write
    movq $54, %rdx                   #the number of bytes
    syscall                          

    #generate the initial barcode and store it in buffer
    movq $buffer, %rdi
    call generateInitialBarcode

    #encode the string
    movq $inputString, %rdi
    movq $encodedMessage, %rsi
    call encodeRLE

    #execute the XOR operation
    movq $buffer, %rdi
    movq $encodedMessage, %rsi
    call executeXOR

    #insert content to file
    movq $1, %rax                    #system call - write in the file
    movq %r14, %rdi                  #the file description
    movq $buffer, %rsi               #the address of buffer to write
    movq $3072, %rdx                 #the number of bytes
    syscall                          

    #close the file
    movq $3, %rax                    #system call - close file
    movq %r14, %rdi                  #the file description
    syscall                          

end:
    #restore the callee-saved register
    popq %r14
    popq %r14

    #epilogue
    movq %rbp, %rsp
    popq %rbp

    #exit
    mov $60, %rax
    syscall
