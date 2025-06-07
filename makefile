CFLAGS=-O0 -g -fno-omit-frame-pointer -fno-inline -I./include
LDFLAGS=-rdynamic -ldl

AS_SRCS=$(shell find src/ -name '*.s')
C_SRCS=$(shell find src/ -name '*.c')
AS_OBJS=$(AS_SRCS:.s=.o)
C_OBJS=$(C_SRCS:.c=.o)

all: lib/libdebug.o test/main
	./test/main

lib/libdebug.o: $(AS_OBJS) $(C_OBJS)
	ld -r -o $@ $^

test/main: test/main.c lib/libdebug.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%.o: %.s
	$(AS) -64 -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(AS_OBJS) $(C_OBJS) lib/libdebug.o test/main

.PHONY: all clean