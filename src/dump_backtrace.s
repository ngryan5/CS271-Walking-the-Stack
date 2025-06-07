.extern _debug_dump_backtrace_frame
.globl dump_backtrace
.type dump_backtrace, @function

dump_backtrace:
    # Save registers we'll use
    pushq %rbx      
    pushq %r12      
    
    # Initialize depth counter
    xorq %r12, %r12
    
    # The key insight: when dump_backtrace is called from level4,
    # we want to show level4 as frame 0, but our current approach
    # is showing the return address FROM dump_backtrace TO level4,
    # which resolves to level3 (the calling function).
    
    # We need to show the return address FROM level4 TO level3 instead.
    # That's at 8((%rbp))
    
    # Start from caller's frame (level4's frame)
    movq (%rbp), %rbx       # rbx = level4's frame pointer
    
backtrace_loop:
    testq %rbx, %rbx
    jz backtrace_done
    
    # Basic safety check
    cmpq $0x1000, %rbx
    jb backtrace_done
    
    # Get return address from current frame
    movq 8(%rbx), %rsi
    testq %rsi, %rsi
    jz backtrace_done
    
    # Print frame
    movq %r12, %rdi
    call _debug_dump_backtrace_frame
    incq %r12
    
    # Move to next frame
    movq (%rbx), %rbx
    
    # Safety limit
    cmpq $10, %r12
    jae backtrace_done
    
    jmp backtrace_loop
    
backtrace_done:
    popq %r12
    popq %rbx
    ret