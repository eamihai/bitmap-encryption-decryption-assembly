.data
    fileContent: .skip 3126
    output: .byte 0
    myString: .skip 3072
    result: .skip 3072

.bss
    initialBarcode: .skip 3072

.text
    fname: .asciz "image.bmp"
    .include "generateInitialBarcode.s"
    .include "executeXOR.s"
    template: .asciz "%d"
    templateChar: .asciz "%c"

.global main

main:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    movq $2, %rax          #system call - open the file
    movq $0, %rsi          #the flags
    movq $0, %rdx          #the mode
    movq $fname, %rdi      ##the file name
    syscall

    #save the file description in a callee-saved register
    pushq %r14
    pushq %r14
    pushq %rbx
    pushq %rbx
    movq %rax, %r14

    movq $0, %rax            #system call - read the file
    movq %r14, %rdi          #the file description
    movq $fileContent, %rsi  #the loaction of the read data
    movq $3126, %rdx         #the number of bytes
    syscall

    movq $initialBarcode, %rdi
    call generateInitialBarcode

    #execute XOR
    movq $fileContent, %rdi
    add $54, %rdi
    movq $initialBarcode, %rsi
    call executeXOR

    movq $fileContent, %rbx
    add $54, %rbx
    movq $0, %r13 #the number of characters
    movq $0, %r14 #the index
    movq $myString, %r15 #the location of the future string

    #make the inverse RLE encoding
    loopDecoder:
        #reach the end of the block
        cmp $3072, %r14
        je truncate
        inc %r14

        #reach the end of the block
        movq $0, %rax
        movb (%rbx), %al
        cmp $0, %rax
        je truncate

        inc %rbx
        movb (%rbx), %cl

        #construct the string
        #%rax - amount
        #%rcx - the character
        loopCompute:
            cmp $0, %rax
            je endLoopCompute
            dec %rax
            
            movb %cl, (%r15)
            inc %r15
            inc %r13
            jmp loopCompute
        
        endLoopCompute:

        inc %rbx
        jmp loopDecoder

#remove trailing and leading    
truncate:
    movq $myString, %rdi
    add $30, %rdi #remove the leading
    movq $result, %rsi

    sub $60, %r13
    #remove the trailing by printing
    #just the required characters
    loopTruncate:
        cmp $0, %r13 #%r13 the number of required characters to print
        je printString
        dec %r13

        movb (%rdi), %al #move the characters in the memory
        movb %al, (%rsi)
        inc %rdi
        inc %rsi

        jmp loopTruncate  #loop again

printString:
    movq $result, %rbx

    #print the characters
    #%rax - the character
    loopPrintString:
        movq $0, %rax
        movb (%rbx), %al  #fetch the character
        inc %rbx

        cmp $0, %rax #reach the end of the string
        je end

        movb %al, output
        movq $1, %rax
        movq $1, %rdi 
        movq $output, %rsi
        movq $1, %rdx
        syscall #print the character

        jmp loopPrintString

end:
    #print and end of line
    movb $10, output
    movq $1, %rax
    movq $1, %rdi 
    movq $output, %rsi
    movq $1, %rdx
    syscall #print the end of line

    #restore the callee-saved register
    popq %rbx
    popq %rbx
    popq %r14
    popq %r14

    #epilogue
    movq %rbp, %rsp
    popq %rbp

    #exit
    mov $60, %rax
    syscall
    