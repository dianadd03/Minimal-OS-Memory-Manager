.data
    task:.space 4
    descriptor:.space 4
    size:.space 4
    n:.space 4
    T:.space 4
    start:.space 4
    finish:.space 4
    lineIndex: .space 4
    columnIndex: .space 4
    mat:.space 4194304 
    N:.long 1024
    formatScanf:.asciz "%d\n"
    formatPrintfTest1:.asciz "%d\n"
    formatPrintfADD:.asciz "%d: ((%d, %d), (%d, %d))\n"
    formatPrintfGET:.asciz "((%d, %d), (%d, %d))\n"

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
    /*
    mov $3, %eax
    cmp task, %eax
    je et_delete

    mov $4, %eax
    cmp task, %eax
    je et_defragmentation*/

/*ADD------------------------------------------------------------ */
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

addd_ret: /*afisare */
    push finish
    push lineIndex
    push start
    push lineIndex
    push descriptor
    push $formatPrintfADD
    call printf
    add $24, %esp

add_ret_Xafis:
    pop %ecx
    inc %ecx
    jmp et_add_loop

et_add_exit:
    pop %ecx
    inc %ecx
    jmp loop_T



addd:
    movl $0, lineIndex
    forA_lines:
        movl lineIndex, %ecx
        cmp %ecx, N
        je add_ret_Xafis

        movl $-1, start
        movl $-1, finish
        movl $0, columnIndex

        forA_columns:
            mov columnIndex, %ecx
            cmp %ecx, N
            je cont_lines

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %edx

            mov $0, %ebp
            cmp $0, %edx
            je addd_ifs

            mov finish, %edi
            sub start, %edi
            add $1, %edi

            cmp size, %edi
            jge addd_actualizare

            movl $-1, start
            movl $-1, finish

        cont_columns:
            incl columnIndex
            jmp forA_columns


    cont_lines:
        mov finish, %edi
        sub start, %edi
        add $1, %edi

        cmp size, %edi
        jge addd_actualizare

        incl lineIndex
        jmp forA_lines


addd_if1:
    mov columnIndex, %ebp
    mov %ebp, start
    jmp cont_columns

addd_ifs:
    mov $-1, %ebp
    cmp start, %ebp
    je addd_if1

    mov columnIndex, %ebp
    mov %ebp, finish

    mov finish, %edi
    sub start, %edi
    add $1, %edi

    cmp size, %edi
    jge addd_actualizare

    jmp cont_columns

addd_actualizare:
    movl start, %ecx
loop_actualizare:
    cmp %ecx, finish
    jl addd_ret

    mov $0, %edx
    movl lineIndex, %eax
    mull N
    add %ecx, %eax

    movl descriptor, %edx
    movl %edx, (%esi, %eax, 4)

    inc %ecx
    jmp loop_actualizare

/*GET---------------------------------------------------------- */

et_get:
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp

get:
    mov $mat, %esi
    movl $0, lineIndex
    forG_lines:
        movl lineIndex, %ecx
        cmp %ecx, N
        je get_ret

        movl $-1, start
        movl $-1, finish
        movl $0, columnIndex

        forG_columns:
            mov columnIndex, %ecx
            cmp %ecx, N
            je contG_lines

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %edx

            cmp descriptor, %edx
            je get_ifs

            mov $-1, %ebp
            cmp %ebp, finish
            jne contG_lines

        contG_columns:
            incl columnIndex
            jmp forG_columns


    contG_lines:
        mov finish, %edi
        add start, %edi
        mov $-2, %ebp
        cmp %ebp, %edi
        jne afisare_get

        incl lineIndex
        jmp forG_lines


get_ifs:
    mov $-1, %ebp
    cmp start, %ebp
    je get_if1

    mov columnIndex, %ebp
    mov %ebp, finish
    jmp contG_columns

get_if1:
    mov columnIndex, %ebp
    mov %ebp, start
    jmp contG_columns

get_ret:
    mov $-1, %ebp
    cmp start, %ebp
    je get_actualizare

afisare_get:
    push finish
    push lineIndex
    push start
    push lineIndex
    push $formatPrintfGET
    call printf
    add $20, %esp

    pop %ecx
    inc %ecx
    jmp loop_T

get_actualizare:
    movl $0, start
    movl $0, finish

    jmp afisare_get


/*DELETE--------------------------------------------------------- */
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



/*DEFRAGMENTATION */
afisare_v:
    xor %ecx, %ecx
    mov $mat, %esi
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

et_exit:
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80

