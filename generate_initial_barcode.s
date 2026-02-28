#generate the initial barcode and put it in the memory pointed by %rdi
generateInitialBarcode:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    movq $1, %rcx #the row

    loop1:
        movq $1, %rdx #the column
        
        loop2:
            cmp $32, %rdx
            je redPixel

            cmp $8, %rdx
            jle whitePixel
            cmp $16, %rdx
            jle blackPixel
            cmp $20, %rdx
            jle whitePixel
            cmp $24, %rdx
            jle blackPixel
            cmp $26, %rdx
            jle whitePixel
            cmp $29, %rdx
            jle blackPixel
            jg whitePixel

        whitePixel:

            movq $0, %rax
            movb $255, (%rdi,%rax,1)
            inc %rax
            movb $255, (%rdi,%rax,1)
            inc %rax
            movb $255, (%rdi,%rax,1)
            add $3, %rdi

            inc %rdx
            jmp loop2

        blackPixel:
            movq $0, %rax
            movb $0, (%rdi,%rax,1)
            inc %rax
            movb $0, (%rdi,%rax,1)
            inc %rax
            movb $0, (%rdi,%rax,1)
            add $3, %rdi

            inc %rdx
            jmp loop2

        redPixel:
            movq $0, %rax
            movb $0, (%rdi,%rax,1)
            inc %rax
            movb $0, (%rdi,%rax,1)
            inc %rax
            movb $255, (%rdi,%rax,1)
            add $3, %rdi

        inc %rcx
        cmp $32, %rcx
        jle loop1

    #epilogue
    movq %rbp, %rsp
    popq %rbp

    #return to main
    ret
