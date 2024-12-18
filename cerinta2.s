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
            je contD_lines

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

delete_ret:
    pop %ecx
    inc %ecx
    jmp loop_T



/*DEFRAGMENTATION */
et_defragmentation:
    defrag_linii:
    mov $mat, %esi
    movl $0, lineIndex
    forDf_lines:
        movl lineIndex, %ecx
        cmp %ecx, N
        je defrag_mutare

        movl $0, k /*k*/
        movl $0, columnIndex
        forDf_columns:
            mov columnIndex, %ecx
            cmp %ecx, N
            je contDf_lines

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %edi/*mat[i][j] */
            mov $0, %ebp
            cmp %edi, %ebp
            jne swap_defrag

        contDf_columns:
            incl columnIndex
            jmp forDf_columns


    contDf_lines:
        incl lineIndex
        jmp forDf_lines

swap_defrag:
    mov $0, %edx
    mov $0, %eax
    mov lineIndex, %eax
    mull N
    add k, %eax
    movl (%esi, %eax, 4), %ebp /*aux=mat[i][k] */
    movl %edi, (%esi, %eax, 4)/*mat[i][k]=mat[i][j] */
    mov $0, %edx
    mov $0, %eax
    mov lineIndex, %eax
    mull N
    add columnIndex, %eax
    movl %ebp, (%esi, %eax, 4)/*mat[i][j]=aux*/
    addl $1, k
    jmp contDf_columns

defragmentation_ret:
    pop %ecx
    inc %ecx
    jmp loop_T



defrag_mutare:
    mov $mat, %esi
    movl $0, lineIndex
    forDfm_lines:
        movl lineIndex, %ecx
        subl N, %ecx
        mov $-1, %ebp
        cmp %ecx, %ebp
        je defrag_linii2

        movl $0, k /*k*/
        movl $0, columnIndex
        forDfm_columns:
            mov columnIndex, %ecx
            cmp %ecx, N
            je contDfm_lines

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %edi/*mat[i][j] */
            mov $0, %ebp
            cmp %edi, %ebp
            je defrag_mut_ifs

        contDfm_columns:
            incl columnIndex
            jmp forDfm_columns


    contDfm_lines:
        incl lineIndex
        jmp forDfm_lines
defrag_mut_ifs:
    mov $0, %ebp
    cmp k, %ebp
    je defrag_mut_if1
defrag_mut_ifs_cont:
    mov $0, %ebp
    cmp k, %ebp
    jle defrag_mut_if2

    jmp contDfm_columns


defrag_mut_if1:
    mov $mat, %esi
    mov $0, %edx
    mov $0, %eax
    mov lineIndex, %eax
    add $1, %eax
    mull N

    movl (%esi, %eax, 4), %edi/*mat[i+1][0] */
    mov %edi, %ebx /*valc */
    movl $0, %ecx
    for_h:
        cmp %ecx, N
        je if1_cont

        mov $mat, %esi
        mov $0, %edx
        mov $0, %eax
        mov lineIndex, %eax
        add $1, %eax
        mull N
        add %ecx, %eax
        movl (%esi, %eax, 4), %edi/*mat[i+1][h] */

        cmp %edi, %ebx
        jne if1_cont
        incl k

    conth:
        inc %ecx
        jmp for_h
    if1_cont:
        subl $1, k
        jmp defrag_mut_ifs_cont


defrag_mut_if2:
    mov k, %ebp
    add columnIndex, %ebp
    cmp %ebp, N
    jle contDfm_columns

    mov $mat, %esi
    mov $0, %edx
    mov $0, %eax
    mov lineIndex, %eax
    mull N
    add columnIndex, %eax

    movl %ebx, %ebp
    movl %ebp, (%esi, %eax, 4)
    mov $mat, %esi
    mov $0, %edx
    mov $0, %eax
    mov lineIndex, %eax
    add $1, %eax
    mull N
    add k, %eax
    movl $0, (%esi, %eax, 4)
    subl $1, k
    jmp contDfm_columns


defrag_linii2:
    mov $mat, %esi
    movl $0, lineIndex
    forDf2_lines:
        movl lineIndex, %ecx
        cmp %ecx, N
        je defrag_afis

        movl $0, k 
        movl $0, columnIndex
        forDf2_columns:
            mov columnIndex, %ecx
            cmp %ecx, N
            je contDf2_lines

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %edi/*mat[i][j] */
            mov $0, %ebp
            cmp %edi, %ebp
            jne swap_defrag2

        contDf2_columns:
            incl columnIndex
            jmp forDf2_columns


    contDf2_lines:
        incl lineIndex
        jmp forDf2_lines

swap_defrag2:
    mov $0, %edx
    mov $0, %eax
    mov lineIndex, %eax
    mull N
    add k, %eax
    movl (%esi, %eax, 4), %ebp /*aux=mat[i][k] */
    movl %edi, (%esi, %eax, 4)/*mat[i][k]=mat[i][j]*/ 
    mov $0, %edx
    mov $0, %eax
    mov lineIndex, %eax
    mull N
    add columnIndex, %eax
    movl %ebp, (%esi, %eax, 4)/*mat[i][j]=aux*/
    addl $1, k
    jmp contDf2_columns



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
            je contDfa_lines

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

/*------------------------------------------------------------ */
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
    pushl $0
    call fflush
    popl %eax
    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80

