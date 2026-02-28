#encode the string pointed by %rdi in the memory pointed by %rsi
encodeRLE:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    addLead:
        #8xC
        movb $8, (%rsi)
        inc %rsi
        movb $67, (%rsi)
        inc %rsi

        #4xS
        movb $4, (%rsi)
        inc %rsi
        movb $83, (%rsi)
        inc %rsi

        #2xE
        movb $2, (%rsi)
        inc %rsi
        movb $69, (%rsi)
        inc %rsi

        #4x1
        movb $4, (%rsi)
        inc %rsi
        movb $49, (%rsi)
        inc %rsi

        #4x4
        movb $4, (%rsi)
        inc %rsi
        movb $52, (%rsi)

    movq $0, %rax #the previous character
    movq $0, %rbx #the current character
    movq $8, %rcx #the counter
    movb $48, %al
    loopEncode:
        movb (%rdi), %bl
        inc %rdi
        cmp $0, %rbx
        je addTrail

        cmp %rax, %rbx
        je equalCharacters
        jne unequalCharacters

        equalCharacters:
            inc %rcx
            jmp loopEncode
        unequalCharacters:
            inc %rsi
            movb %cl, (%rsi)
            inc %rsi
            movb %al, (%rsi)
            movq %rbx, %rax
            movq $1, %rcx
            jmp loopEncode    

    addTrail:
        cmp $67, %rax
        je equalsToLast
        jne unequalsToLast

        equalsToLast:
            add $8, %rcx
            inc %rsi
            movb %cl, (%rsi)
            inc %rsi
            movb $67, (%rsi)
            jmp endTrail
        unequalsToLast:
            inc %rsi
            movb %cl, (%rsi)
            inc %rsi
            movb %al, (%rsi)
            
            #8xC
            inc %rsi
            movb $8, (%rsi)
            inc %rsi
            movb $67, (%rsi)
            jmp endTrail
        endTrail:
            #4xS
            inc %rsi
            movb $4, (%rsi)
            inc %rsi
            movb $83, (%rsi)

            #2xE
            inc %rsi
            movb $2, (%rsi)
            inc %rsi
            movb $69, (%rsi)

            #4x1
            inc %rsi
            movb $4, (%rsi)
            inc %rsi
            movb $49, (%rsi)

            #4x4
            inc %rsi
            movb $4, (%rsi)
            inc %rsi
            movb $52, (%rsi)

            #8x0
            inc %rsi
            movb $8, (%rsi)
            inc %rsi
            movb $48, (%rsi)

endEncode:
    #epilogue
    movq %rbp, %rsp
    popq %rbp

    #return to main
    ret
    