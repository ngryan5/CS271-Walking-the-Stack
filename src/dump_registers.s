.extern _debug_dump_registers
.globl dump_registers
.type dump_registers, @function

dump_registers:
    # Store all registers to stack immediately
    # We'll allocate space and store them without using any register arithmetic
    
    # Allocate space for 16 registers
    subq $128, %rsp
    
    # Store registers in order, using immediate memory addressing
    # rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp, r8-r15
    movq %rax, 0(%rsp)      # rax
    movq %rbx, 8(%rsp)      # rbx  
    movq %rcx, 16(%rsp)     # rcx
    movq %rdx, 24(%rsp)     # rdx
    movq %rsi, 32(%rsp)     # rsi
    movq %rdi, 40(%rsp)     # rdi
    movq %rbp, 48(%rsp)     # rbp
    
    # For rsp, we need caller's value: current rsp + 128 (our space) + 8 (return addr)
    movq %rsp, %rax
    addq $136, %rax         # Calculate caller's rsp
    movq %rax, 56(%rsp)     # Store caller's rsp
    movq 0(%rsp), %rax      # Restore original rax
    
    movq %r8, 64(%rsp)      # r8
    movq %r9, 72(%rsp)      # r9
    movq %r10, 80(%rsp)     # r10
    movq %r11, 88(%rsp)     # r11
    movq %r12, 96(%rsp)     # r12
    movq %r13, 104(%rsp)    # r13
    movq %r14, 112(%rsp)    # r14
    movq %r15, 120(%rsp)    # r15
    
    # Call helper function
    movq %rsp, %rdi
    call _debug_dump_registers
    
    # Restore stack
    addq $128, %rsp
    ret