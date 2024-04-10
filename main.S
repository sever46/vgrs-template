/* unconditional link jump to the start of the program
   call exit system call on return to avoid errors */
.syntax unified

/* link jump to the start function */
bl _start
/* set the exit code to 1, aka abnormal exit */
mov r0, 1
/* call the syscall exit */
svc 0x10

/* infinite loop in case the system call fails */
.loop:
	b .loop
