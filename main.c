#include <oslib/syscall.h>

// entry point
void _start(gameinit_t *ptr) {
	char str[] = "Hello, world!\n";
	puts(str, sizeof(str));
	flush();
	while (1) {}
}
