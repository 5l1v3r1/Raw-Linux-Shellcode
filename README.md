# Raw Shellcode
Some C and x86 Assembly code to build a shell-spawning shellcode from scratch
(No ASLR, Canary, NX, PIE)

### Configurations

#### Assemble .s files

`nasm <file.s>`

#### Check shellcode length

`wc -c <file>`

#### Check for null bytes

`hexdump -C <file> | grep --color=auto 00`

#### Get shellcode environment variable location

`export SHELLCODE=$(cat <file>)`

`./getenvaddr SHELLCODE ./<vulnProgram>`
