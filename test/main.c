#include "debug.h"
#include <stdio.h>

// Use volatile and side effects to prevent optimization
volatile int global_var = 0;

__attribute__((noinline))
void g(int rdi, int rsi, int rdx, int rcx, int r8, int r9)
{
  // Add side effects to prevent optimization
  global_var += rdi + rsi + rdx + rcx + r8 + r9;
  if (global_var > 1000) printf("Side effect\n");
  
  dump_registers();
  dump_backtrace();
  
  global_var += 100; // More side effects
}

__attribute__((noinline))
int no_op(void) { 
  global_var++;
  if (global_var > 1000) printf("Side effect\n");
  return 42; 
}

__attribute__((noinline))
void f()
{
  int result = no_op();
  global_var += result;
  if (global_var > 1000) printf("Side effect\n");
  
  g(1, 2, 3, 4, 5, 6);
  
  global_var += result; // Use result after call
}

int main()
{
  global_var = 0;
  if (global_var > 1000) printf("Starting\n");
  
  f();
  
  return global_var > 1000 ? 1 : 0;
}