#execute store between memory pointed bt %rdi and %rsi and store it in %rdi
executeXOR:
    #prologue
    pushq %rbp
    movq %rsp, %rbp
    
    movq $0, %rax
    loopExecuteXOR:
        cmp $384, %rax
        je endExecuteXOR
        inc %rax

        movq (%rdi), %rbx
        movq (%rsi), %rcx
        xor %rcx, %rbx
        movq %rbx, (%rdi)
        add $8, %rdi
        add $8, %rsi

        jmp loopExecuteXOR

endExecuteXOR:
    #epilogue
    movq %rbp, %rsp
    popq %rbp

    #return to main
    ret
