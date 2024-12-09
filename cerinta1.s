.data
    task:.space 4
    descriptor:.space 4
    size:.space 4
    n:.space 4
    T:.space 4
    v:.space 4096
    N:.long 1024
    formatScanf:.asciz "%d\n"
    formatPrintfTest1:.asciz "%d\n"
    /*formatPrintfTestT:.asciz " T: %d\n"
    formatPrintfTestn:.asciz "n: %d\n"
    formatPrintfTestTask:.asciz "task: %d\n"
    formatPrintfTestDes:.asciz "descriptor: %d\n"
    formatPrintfTestSize:.asciz "size: %d\n"*/
    formatPrintfADD:.asciz "%d: (%d, %d)\n"
    formatPrintfGET:.asciz "(%d, %d)\n"

.text
.global main

main:
    /*citire T*/
    push $T
    push $formatScanf
    call scanf
    add $8, %esp

    xor %ecx, %ecx

loop_T:
    cmp T, %ecx
    je et_exit

    push %ecx

    //citire task
    push $task
    push $formatScanf
    call scanf
    add $8, %esp
    
    mov $1, %eax
    cmp task, %eax
    je et_add

    mov $2, %eax
    cmp task, %eax
    je et_get
    
    mov $3, %eax
    cmp task, %eax
    je et_delete

    mov $4, %eax
    cmp task, %eax
    je et_defragmentation

/*ADD----------------------------------------------------------------------------------------------------------------- */
et_add:
    push $n
    push $formatScanf
    call scanf
    add $8, %esp

    xor %ecx, %ecx
et_add_loop:
    cmp n, %ecx
    je et_add_exit
    push %ecx

    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp

    push $size
    push $formatScanf
    call scanf
    add $8, %esp   

    mov size, %eax
    mov $0, %edx
    mov $8, %ebx
    div %ebx

    mov $0, %ebp
    cmp %edx, %ebp
    jl size_act 

    mov %eax, size
ret_size_act:
    jmp addd

size_act:
    add $1, %eax
    mov %eax, size
    jmp ret_size_act
addd_ret:
    push %ebx
    push %eax
    push descriptor
    push $formatPrintfADD
    call printf
    add $16, %esp

add_ret_Xafis:
    pop %ecx
    inc %ecx
    jmp et_add_loop

et_add_exit:
    pop %ecx
    inc %ecx
    jmp loop_T




addd:
    mov $-1, %eax /*start*/
    mov $-1, %ebx /*finish*/

    xor %ecx, %ecx
    mov $v, %esi
loop_addd:
    cmp %ecx, N
    je add_ret_Xafis

    movl (%esi, %ecx, 4), %edx
    mov $0, %ebp
    cmp %edx, %ebp
    je addd_ifs

    mov %ebx, %edi
    sub %eax, %edi
    add $1, %edi

    cmp size, %edi
    jge addd_actualizare

    mov $-1, %eax /*start*/
    mov $-1, %ebx /*finish*/

loopadd_ret:
    inc %ecx
    jmp loop_addd  

addd_ifs:
    mov $-1, %ebp
    cmp %eax, %ebp
    je addd_if1

    /*else*/
    mov %ecx, %ebx

    mov %ebx, %edi
    sub %eax, %edi
    add $1, %edi

    cmp size, %edi
    jge addd_actualizare

    jmp loopadd_ret

addd_if1:
    mov %ecx, %eax
    jmp loopadd_ret

addd_actualizare:
    mov %eax, %ecx

loop_actualizare:
    cmp %ecx, %ebx
    jl addd_ret

    movl (%esi, %ecx, 4), %edx
    mov descriptor, %edx
    movl %edx, (%esi, %ecx, 4)

    inc %ecx
    jmp loop_actualizare

/*GET-------------------------------------------------------------------------------------------------------- */

et_get:
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp

get:
    mov $-1, %eax
    mov $-1, %ebx
    xor %ecx, %ecx
    mov $v, %esi

loop_get:
    cmp %ecx, N
    je get_ret

    movl (%esi, %ecx, 4), %edx

    cmp %edx, descriptor
    je get_ifs

    mov $-1, %ebp
    cmp %ebx, %ebp
    jne get_ret


loopget_ret:
    inc %ecx
    jmp loop_get

get_ifs:
    mov $-1, %ebp
    cmp %eax, %ebp
    je get_if1

    mov %ecx, %ebx
    jmp loopget_ret

get_if1:
    mov %ecx, %eax
    jmp loopget_ret

get_ret:
    mov $-1, %ebp
    cmp %eax, %ebp
    je get_actualizare

afisare_get:
    push %ebx
    push %eax
    push $formatPrintfGET
    call printf
    add $12, %esp

    pop %ecx
    inc %ecx
    jmp loop_T

get_actualizare:
    mov $0, %eax
    mov $0, %ebx

    jmp afisare_get

/*DELETE-------------------------------------------------------------------------------------------------------------- */
et_delete:
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp

delete:
    mov $0, %eax
    mov $-1, %ebx
    xor %ecx, %ecx
    mov $v, %esi
    movl (%esi, %ecx, 4), %edi /*valc*/

loop_delete:
    cmp %ecx, N
    je delete_ret

    movl (%esi, %ecx, 4), %edx

    cmp %edx, %edi
    jne delete_ifs

loopdelete_ret:
    cmp %edx, descriptor
    je delete_actualizare
loop_del_ret:
    inc %ecx
    jmp loop_delete

delete_ifs:
    mov %ecx, %ebx
    sub $1, %ebx

    cmp %edi, descriptor
    jne delete_afisare

delete_afis_ret:
    mov %ecx, %eax
    mov %edx, %edi

    jmp loopdelete_ret

delete_actualizare:
    mov $0, %ebp
    movl %ebp,  (%esi, %ecx, 4)
    jmp loop_del_ret

delete_afisare:
    mov $0, %ebp
    cmp %edi, %ebp
    je delete_afis_ret

    push %edx
    push %ecx
    push %ebx
    push %eax
    push %edi
    push $formatPrintfADD
    call printf
    add $4, %esp
    pop %edi
    pop %eax
    pop %ebx
    pop %ecx
    pop %edx

    jmp delete_afis_ret

delete_ret:
    pop %ecx
    inc %ecx
    jmp loop_T

/*DEFRAGMENTATION-------------------------------------------------------------------------------------------------------- */
et_defragmentation:
    mov $0, %eax
    xor %ecx, %ecx
    mov $v, %esi

loop_defragmentation:
    cmp %ecx, N
    je defrag_afis

    movl (%esi, %ecx, 4), %edx/*v[i] */
    mov $0, %ebp

    cmp %edx, %ebp
    jne swap_defrag

defrag_loop_ret:
    inc %ecx
    jmp loop_defragmentation


swap_defrag:
    movl (%esi, %eax, 4), %ebx /*v[k] */
    movl %edx, (%esi, %eax, 4)
    movl %ebx, (%esi, %ecx, 4)
    inc %eax
    jmp defrag_loop_ret

defrag_afis:
    mov $0, %eax
    mov $-1, %ebx
    xor %ecx, %ecx
    mov $v, %esi
    movl (%esi, %ecx, 4), %edi /*valc*/


loop_defrag_afis:
    cmp %ecx, N
    je defragmentation_ret

    movl (%esi, %ecx, 4), %edx

    cmp %edx, %edi
    jne defrag_if

loop_defrag_ret:
    inc %ecx
    jmp loop_defrag_afis

defrag_if:
    mov %ecx, %ebx
    sub $1, %ebx

defrag_afisare:
    push %edx
    push %ecx
    push %ebx
    push %eax
    push %edi
    push $formatPrintfADD
    call printf
    add $4, %esp
    pop %edi
    pop %eax
    pop %ebx
    pop %ecx
    pop %edx


defrag_afis_ret:
    mov %ecx, %eax
    mov %edx, %edi

    jmp loop_defrag_ret

defragmentation_ret:
    pop %ecx
    inc %ecx
    jmp loop_T


/*
afisare_v:
    xor %ecx, %ecx
    mov $v, %esi
loop:
    cmp %ecx, N
    je et_exit

    movl (%esi, %ecx, 4), %eax

    push %ecx

    push %eax
    push $formatPrintfTest1
    call printf
    add $8, %esp
    pop %ecx
control:
    inc %ecx

    jmp loop   
*/
et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80

