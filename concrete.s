.section .data
folderPath: .space 256           # Spațiu pentru calea directorului
buffer: .space 256               # Spațiu pentru numele fișierelor
filePath: .space 512             # Spațiu pentru calea completă
format_string: .asciz "%d %ld\n" # Format pentru printf
dir_msg: .asciz "Enter directory path: "

.section .text
.global _start

_start:
    # Scrie mesaj pentru a cere calea directorului
    movl $4, %eax                # sys_write
    movl $1, %ebx                # File descriptor (stdout)
    movl $dir_msg, %ecx          # Adresa mesajului
    movl $22, %edx               # Lungimea mesajului
    int $0x80                    # Apelul de sistem
    
    # Citește calea directorului cu scanf
    pushl $folderPath            # Adresa bufferului pentru rezultat
    pushl $input_format          # Format string-ul
    call scanf                   # Apelă scanf
    addl $8, %esp                # Curăță stiva

    # Deschide directorul
    movl $folderPath, %ebx       # Calea directorului
    movl $opendir, %eax          # Apelă opendir
    call *%eax                   # Director pointer
    movl %eax, %ebx              # Salvează directorul în %ebx

read_dir:
    movl $readdir, %eax          # Apelă readdir
    movl %ebx, %ecx              # Descriptor director
    call *%eax                   # Citește următoarea intrare
    test %eax, %eax              # Verifică sfârșitul
    je close_dir

    # Verifică dacă numele începe cu '.'
    movb (%eax), %al             # Primul caracter din nume
    cmpb $'.', %al
    je read_dir                  # Sar dacă este fișier ascuns

    # Construiește calea completă
    movl $folderPath, %edi
    movl $filePath, %esi
copy_path:
    movb (%edi), %al
    movb %al, (%esi)
    testb %al, %al
    je append_slash
    incl %edi
    incl %esi
    jmp copy_path
append_slash:
    movb $'/', (%esi)
    incl %esi

    # Copiază numele fișierului
    movl %eax, %edi
copy_name:
    movb (%edi), %al
    movb %al, (%esi)
    testb %al, %al
    je open_file
    incl %edi
    incl %esi
    jmp copy_name

open_file:
    movl $open, %eax
    movl $filePath, %ebx         # Calea completă
    movl $0, %ecx                # Mod citire (O_RDONLY)
    call *%eax
    movl %eax, %esi              # Descriptor fișier

    # Obține informații despre fișier
    movl $fstat, %eax
    movl %esi, %ebx              # File descriptor
    movl $buffer, %ecx           # Stat buffer
    call *%eax

    # Calculează dimensiunea în KB
    movl buffer+28, %eax         # st_size din struct stat
    shrl $10, %eax               # Împarte la 1024

    # Calculează FD % 255 + 1
    movl %esi, %edx
    movl $255, %ecx
    divl %ecx
    incl %edx

    # Afișează rezultatele
    pushl %eax                   # Dimensiunea
    pushl %edx                   # FD modificat
    pushl $format_string
    call printf
    addl $12, %esp               # Curăță stiva

    # Închide fișierul
    movl $close, %eax
    movl %esi, %ebx
    call *%eax

    jmp read_dir

close_dir:
    movl $closedir, %eax
    movl %ebx, %ecx
    call *%eax

exit_program:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
