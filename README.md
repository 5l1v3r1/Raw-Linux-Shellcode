# Raw Shellcode

Some C and x86 Assembly code to build a shell-spawning shellcode from scratch

Tested on **Linux Kernel 2.6.20**

### Configurations

#### Assemble .s files

`nasm <shellcode.s>`

#### Check shellcode length

`wc -c <shellcodeBin>`

#### Check for null bytes

`hexdump -C <shellcodeBin> | grep --color=auto 00`

#### Get shellcode env address

**ASLR disabled**

`export SHELLCODE=$(cat <shellcodeBin>)`

`./getenvaddr SHELLCODE ./<vulnProgram>`
