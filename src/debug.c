#define _GNU_SOURCE
#include <stdio.h>
#include <dlfcn.h>
#include "debug.h"

char const *regnames[] = {
    "rax",
    "rbx", 
    "rcx",
    "rdx",
    "rsi",
    "rdi",
    "rbp",
    "rsp",
    "r8",
    "r9",
    "r10",
    "r11",
    "r12",
    "r13",
    "r14",
    "r15",
};

/* Internal helper function */
void
_debug_dump_registers(long const *regs)
{
    for (int i = 0; i < 16; i++) {
        printf("%s\t%ld (0x%lx)\n", regnames[i], regs[i], regs[i]);
    }
}

void
_debug_dump_backtrace_frame(long depth, void *addr)
{
    Dl_info info;
    
    if (dladdr(addr, &info)) {
        printf("%3ld: [%lx] %s () %s\n", 
               depth, 
               (unsigned long)addr,
               info.dli_sname ? info.dli_sname : "(null)",
               info.dli_fname ? info.dli_fname : "(null)");
    } else {
        printf("%3ld: [%lx] (null) () (null)\n", 
               depth, 
               (unsigned long)addr);
    }
}