.data
    task:.space 4
    descriptor:.space 4
    size:.space 4
    n:.space 4
    T:.space 4
    k:.space 4
    start:.space 4
    finish:.space 4
    lineIndex: .space 4
    columnIndex: .space 4
    mat:.space 4194304 
    N:.long 1024
    N2:.long 2048
    NN:.long 4194304 
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
    
    mov $3, %eax
    cmp task, %eax
    je et_delete
    
    mov $4, %eax
    cmp task, %eax
    je et_defragmentation

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
    mov N, %ebp
    cmp size, %ebp
    jge addd

    jmp add_ret_Xafis

size_act:
    add $1, %eax
    mov %eax, size
    jmp ret_size_act

add_ret_Xafis:
    movl $0, start
    movl $0, finish
    movl $0, lineIndex

addd_ret: /*afisare */
    push finish
    push lineIndex
    push start
    push lineIndex
    push descriptor
    push $formatPrintfADD
    call printf
    add $24, %esp

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
    movl $0, lineIndex
    jmp afisare_get


/*DELETE--------------------------------------------------------- */
et_delete:
    push $descriptor
    push $formatScanf
    call scanf
    add $8, %esp

delete:
    mov $mat, %esi
    movl $0, lineIndex
    forD_lines:
        movl lineIndex, %ecx
        cmp %ecx, N
        je delete_ret

        movl $0, start
        movl $-1, finish
        movl $0, columnIndex
        mov $0, %edx
        mov $0, %eax
        mov lineIndex, %eax
        mull N
        add columnIndex, %eax

        movl (%esi, %eax, 4), %ebx /*valc */

        forD_columns:
            mov columnIndex, %ecx
            cmp %ecx, N
            je delete_verif_last

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %edx

            cmp %ebx, %edx
            jne delete_if1
        delete_cont:
            cmp %ebx, descriptor
            je delete_actualizare

        contD_columns:
            incl columnIndex
            jmp forD_columns


    contD_lines:
        incl lineIndex
        jmp forD_lines


delete_if1:
    mov columnIndex, %ebp
    mov %ebp, finish
    subl $1, finish

    cmp %ebx, descriptor
    jne delete_afisare

delete_afis_ret:
    mov columnIndex, %ebp
    mov %ebp, start
    mov %edx, %ebx

    jmp delete_cont

delete_actualizare:
    mov $0, %ebp
    movl %ebp,  (%esi, %eax, 4)
    jmp contD_columns

delete_afisare:
    mov $0, %ebp
    cmp %ebx, %ebp
    je delete_afis_ret

    push %eax
    push %ecx
    push %edx
    push finish
    push lineIndex
    push start
    push lineIndex
    push %ebx
    push $formatPrintfADD
    call printf
    pop %ebx
    add $16, %esp
    pop %ebx
    pop %edx
    pop %ecx
    pop %eax

    jmp delete_afis_ret

delete_verif_last:
    mov N, %ecx
    sub $1, %ecx
    mov %ecx, finish
    mov $0, %edx
    mov lineIndex, %eax
    mull N
    add finish, %eax
    mov (%esi, %eax, 4), %edx

    cmp descriptor, %ebx
    je contD_lines
    cmp %edx, %ebx
    jne contD_lines

delete_afisare_last:
    mov $0, %ebp
    cmp %ebx, %ebp
    je contD_lines
    
    push %eax
    push %ecx
    push %edx
    push finish
    push lineIndex
    push start
    push lineIndex
    push %ebx
    push $formatPrintfADD
    call printf
    pop %ebx
    add $16, %esp
    pop %ebx
    pop %edx
    pop %ecx
    pop %eax

    jmp contD_lines

delete_ret:
    pop %ecx
    inc %ecx
    jmp loop_T



/*DEFRAGMENTATION-----------------------------------------------------*/
et_defragmentation:
    mov $mat, %esi
    movl $0, lineIndex

forDf_i:
    mov lineIndex, %ecx /*i */
    cmpl %ecx, NN
    je defrag_afis

    movl (%esi, %ecx, 4), %edi /*mat[i] */
    movl $0, %ebp
    cmp %edi, %ebp
    jne forDf_i_cont

    mov %ecx, columnIndex /*j */
    movl $0, descriptor /*valc */
    forDf_j:
        mov columnIndex, %ecx
        cmp %ecx, NN
        je fori_cont

        movl (%esi, %ecx, 4), %edi /*mat[j] */

        movl $0, %ebp
        cmpl descriptor, %ebp
        je defrag_if1

        cmp %edi, descriptor
        je forj_cont

        mov columnIndex, %ebp
        sub $1, %ebp
        mov %ebp, finish
        mov %ebp, size
        mov start, %ebp
        sub %ebp, size
        jmp fori_cont

    forj_cont:
        addl $1, columnIndex
        jmp forDf_j

    fori_cont:
        mov $0, %edx
        mov lineIndex, %eax
        mov $1024, %ebp
        div %ebp
        mov $0, %eax
        add size, %edx

        cmp %edx, N
        jg forj2

    forDf_i_cont:
        mov %ebx, lineIndex
        addl $1, lineIndex
        jmp forDf_i


defrag_if1:
    movl $0, %ebp
    cmp %edi, %ebp
    je forj_cont

    mov %edi, descriptor
    mov columnIndex, %ebp
    mov %ebp, start

    jmp forj_cont
forj2:
    mov lineIndex, %ecx
    mov lineIndex, %ebx
    add size, %ebx
forj2_loop:
    cmpl %ecx, %ebx
    jl forDf_i_cont

    movl descriptor, %edi
    movl %edi, (%esi, %ecx, 4)
control1:
    mov start, %eax
    add %ecx, %eax
    sub lineIndex, %eax

    movl $0, (%esi, %eax, 4)

    inc %ecx
    jmp forj2_loop


defrag_afis:
    mov $mat, %esi
    movl $0, lineIndex
    forDfa_lines:
        movl lineIndex, %ecx
        cmp %ecx, N
        je defragmentation_ret

        movl $0, start
        movl $-1, finish
        movl $0, columnIndex
        mov $0, %edx
        mov $0, %eax
        mov lineIndex, %eax
        mull N
        add columnIndex, %eax

        movl (%esi, %eax, 4), %ebx /*valc */

        forDfa_columns:
            mov columnIndex, %ecx
            cmp %ecx, N
            je defrag_verif_last

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %edx

            cmp %ebx, %edx
            jne defraga_if

        contDfa_columns:
            incl columnIndex
            jmp forDfa_columns


    contDfa_lines:
        incl lineIndex
        jmp forDfa_lines


defraga_if:
    mov columnIndex, %ebp
    mov %ebp, finish
    subl $1, finish
defraga_afisare:
    mov $0, %ebp
    cmp %ebx, %ebp
    je defraga_afis_ret

    push %eax
    push %ecx
    push %edx
    push finish
    push lineIndex
    push start
    push lineIndex
    push %ebx
    push $formatPrintfADD
    call printf
    pop %ebx
    add $16, %esp
    pop %ebx
    pop %edx
    pop %ecx
    pop %eax

defraga_afis_ret:
    mov columnIndex, %ebp
    mov %ebp, start
    mov %edx, %ebx

    jmp contDfa_columns


defrag_verif_last:
    mov N, %ecx
    sub $1, %ecx
    mov %ecx, finish
    mov $0, %edx
    mov lineIndex, %eax
    mull N
    add finish, %eax
    mov (%esi, %eax, 4), %edx

    cmp %edx, %ebx
    jne contDfa_lines

defrag_afisare_last:
    mov $0, %ebp
    cmp %ebx, %ebp
    je contDfa_lines
    
    push %eax
    push %ecx
    push %edx
    push finish
    push lineIndex
    push start
    push lineIndex
    push %ebx
    push $formatPrintfADD
    call printf
    pop %ebx
    add $16, %esp
    pop %ebx
    pop %edx
    pop %ecx
    pop %eax

    jmp contDfa_lines

defragmentation_ret:
    pop %ecx
    inc %ecx
    jmp loop_T

/*------------------------------------------------------------ */

et_exit:
    pushl $0
    call fflush
    popl %eax
    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80

