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
    desc:.space 4000
    sz:.space 4000
    N:.long 1024
    stack:.space 4
    filepath:.space 256
    input_format:.asciz "%s\n"
    fileInfo: .space 128
    formatScanf:.asciz "%d\n"
    formatPrintfTest1:.asciz "%d\n"
    formatPrintfADD:.asciz "%d: ((%d, %d), (%d, %d))\n"
    formatPrintfGET:.asciz "((%d, %d), (%d, %d))\n"
    folderPath: .space 256         # Buffer pentru calea directorului
    fullPath: .space 256         # Buffer pentru calea directorului
    direntBuffer: .space 4096      # Buffer pentru struct dirent (4KB)
    format: .asciz "%s\n"          # Format pentru printf
    dotChar: .byte '.'             # Caracter pentru fișiere ascunse
    slashChar: .asciz "/"
    printf_format:.asciz "%d\n%d\n"

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

    mov $5, %eax
    cmp task, %eax
    je et_concrete

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

conc_add:
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
    mov $5, %ebp
    cmp %ebp, task
    je skip_entry

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



/*DEFRAGMENTATION-----------------------------------------------------------------------------------------*/

et_defragmentation:
    mov $mat, %esi
    movl $0, descriptor
    movl $0, size
    movl $0, start
    movl $0, %ebx /* k */
    movl $0, lineIndex

forDf_lines:
    movl lineIndex, %ecx
    cmpl %ecx, N
    je defrag_reform

    movl $0, columnIndex
    forDf_columns:
        movl columnIndex, %ecx
        cmpl %ecx, N
        je forDf_lines_cont

        mov $0, %ebp
        cmpl descriptor, %ebp 
        je defrag_if1

        mov lineIndex, %eax
        mull N
        add columnIndex, %eax
        movl (%esi, %eax, 4), %edx /*mat[i][j] */
        
        cmp %edx, descriptor
        jne defrag_if2
    forDf_col_cont:
        mov $1023, %ebp
        cmp columnIndex, %ebp
        je defrag_if3
    forDf_columns_cont:
        addl $1, columnIndex
        jmp forDf_columns

    forDf_lines_cont:
        addl $1, lineIndex
        jmp forDf_lines        

defrag_if1:
    mov lineIndex, %eax
    mull N
    add columnIndex, %eax

    movl (%esi, %eax, 4), %edi /*mat[i][j] */
    cmpl $0, %edi
    je forDf_columns_cont

    mov %edi, descriptor
    mov columnIndex, %ebp
    mov %ebp, start
    
    jmp forDf_columns_cont   

defrag_if2:
    mov columnIndex, %ebp
    mov %ebp, size
    mov start, %ebp
    subl %ebp, size
    subl $1, size

    mov $desc, %edi
    mov descriptor, %ebp
    mov %ebp, (%edi, %ebx, 4)
    mov $sz, %edi
    mov size, %ebp
    mov %ebp, (%edi, %ebx, 4)
    add $1, %ebx
    movl $0, descriptor
    subl $1, columnIndex

    jmp forDf_col_cont

defrag_if3:
    mov lineIndex, %eax
    mull N
    add columnIndex, %eax

    movl (%esi, %eax, 4), %edi
    cmpl $0, %edi
    je forDf_columns_cont

    mov columnIndex, %ebp
    mov %ebp, size
    mov start, %ebp
    sub %ebp, size
    mov $desc, %edi
    mov descriptor, %ebp
    mov %ebp, (%edi, %ebx, 4)
    mov $sz, %edi
    mov size, %ebp
    mov %ebp, (%edi, %ebx, 4)
    inc %ebx
    movl $0, descriptor

    jmp forDf_columns_cont


defrag_reform:
    movl $-1, finish
    movl $0, lineIndex
    mov %ebx, k
    movl $0, %ebx

    forDfr_lines:
        movl lineIndex, %ecx
        cmpl %ecx, N
        je defrag_afis

        movl $0, columnIndex
        forDfr_columns:
            movl columnIndex, %ecx
            cmpl %ecx, N
            je forDfr_lines_cont

            mov lineIndex, %eax
            mull N
            add columnIndex, %eax
            mov $mat, %esi

            movl $0, (%esi, %eax, 4)
            cmp %ebx, k
            jge Dfr_ifs
        forDfr_columns_cont:
            addl $1, columnIndex
            jmp forDfr_columns
    forDfr_lines_cont:
        addl $1, lineIndex
        jmp forDfr_lines


Dfr_ifs:
    mov $-1, %ebp
    cmpl finish, %ebp
    je Dfr_if1
Dfr_ifs_cont1:
    mov columnIndex, %ebp
    cmp %ebp, finish
    jge Dfr_if2
Dfr_ifs_cont2:
    mov columnIndex, %ebp
    cmp %ebp, finish
    je Dfr_if3
    jmp forDfr_columns_cont

Dfr_if1:
    mov $sz, %esi
    mov (%esi, %ebx, 4), %edx
    mov columnIndex, %ebp
    add %ebp, %edx
    cmp %edx, N
    jle forDfr_columns_cont

    mov %edx, finish
    jmp Dfr_ifs_cont1

Dfr_if2:
    mov $desc, %esi
    movl (%esi, %ebx, 4), %edi
    mov lineIndex, %eax
    mull N
    add columnIndex, %eax
    mov $mat, %esi
    movl %edi, (%esi, %eax, 4)
    jmp Dfr_ifs_cont2

Dfr_if3:
    movl $-1, finish
    addl $1, %ebx

    jmp forDfr_columns_cont


defrag_afis:
    mov k, %ebp
    mov %ebp, n
    movl $0, lineIndex
    forDfa_lines:
        movl lineIndex, %ecx
        cmp %ecx, N
        je defragmentation_ret
        
        mov $mat, %esi
        movl $0, start
        movl $-1, finish
        movl $0, columnIndex
        mov $0, %edx
        mov $0, %eax
        mov lineIndex, %eax
        mull N
        add columnIndex, %eax

        movl (%esi, %eax, 4), %ebp 
        movl %ebp, k/*valc */

        forDfa_columns:
            movl columnIndex, %ecx
            cmp %ecx, N
            je defrag_verif_last

            mov $mat, %esi
            mov $0, %edx
            mov $0, %eax
            mov lineIndex, %eax
            mull N
            add columnIndex, %eax

            movl (%esi, %eax, 4), %ebp
            movl %ebp, descriptor/*mat[i][j] */
            
            movl k, %ebx
            cmp %ebx, descriptor
            jne defraga_if

        contDfa_columns:
            addl $1, columnIndex
            jmp forDfa_columns


    contDfa_lines:
        addl $1, lineIndex
        jmp forDfa_lines


defraga_if:
    mov columnIndex, %ebp
    mov %ebp, finish
    subl $1, finish
defraga_afisare:
    mov $0, %ebp
    cmp k, %ebp
    je defraga_afis_ret

    push %ebx
    push %eax
    push %ecx
    push %edx
    push finish
    push lineIndex
    push start
    push lineIndex
    push k
    push $formatPrintfADD
    call printf
    add $24, %esp
    pop %edx
    pop %ecx
    pop %eax
    pop %ebx

defraga_afis_ret:
    mov columnIndex, %ebp
    mov %ebp, start
    mov descriptor, %ebx
    mov %ebx, k

    jmp contDfa_columns


defrag_verif_last:
    mov N, %ecx
    sub $1, %ecx
    mov %ecx, finish
    mov $0, %edx
    movl lineIndex, %eax
    mull N
    add finish, %eax
    movl (%esi, %eax, 4), %ebp
    movl %ebp, descriptor
    movl k, %ebx
    cmp descriptor, %ebx
    jne contDfa_lines

defrag_afisare_last:
    mov $0, %ebp
    cmp %ebx, %ebp
    je contDfa_lines
    
    push %ebx
    push %eax
    push %ecx
    push %edx
    push finish
    push lineIndex
    push start
    push lineIndex
    push k
    push $formatPrintfADD
    call printf
    add $24, %esp
    pop %edx
    pop %ecx
    pop %eax
    pop %ebx

    jmp contDfa_lines

defragmentation_ret:
    xor %ecx, %ecx
loop:
    cmp %ecx, n
    je defrag_ret

    mov $desc, %esi
    movl $0, (%esi, %ecx, 4)

    mov $sz, %esi
    movl $0, (%esi, %ecx, 4)

    inc %ecx
    jmp loop   

defrag_ret:
    movl $0, n
    pop %ecx
    inc %ecx
    jmp loop_T

/*CONCRETE-------------------------------------------------------------------------------------------------------- */
et_concrete:
    push $folderPath
    push $format
    call scanf
    add $8, %esp

    movl $folderPath, %esi
replace_newline:
    cmpb $0, (%esi)
    je open_dir
    cmpb $10, (%esi)           
    jne replace_next
    movb $0, (%esi)            
replace_next:
    incl %esi
    jmp replace_newline

open_dir:
    movl $folderPath, %ebx    
    movl $0x10000, %ecx       
    movl $5, %eax              
    int $0x80
    testl %eax, %eax
    js et_exit          

    movl %eax, %edi          

read_dir:
    movl $89, %eax             
    movl %edi, %ebx            
    movl $direntBuffer, %ecx   
    movl $4096, %edx           
    int $0x80
    testl %eax, %eax
    jle close_dir             

    movl %eax, %ebx            

    movl $direntBuffer, %esi   
process_entry:
    cmpb $0, (%esi)            
    je read_dir                


    addl $10, %esi             
    movb (%esi), %al
    cmpb dotChar, %al
    je skip_entry
    


    push %eax
    push %ebx
    push %ecx
    push %edx
    push %esi
    push %edi
    push %ebp
    mov %esp, stack
aici:

    mov $fullPath, %ebp
    movb $0, (%ebp)

    push $folderPath
    push $fullPath
    call strcat
    add $8, %esp 

    push $slashChar
    push %eax
    call strcat
    add $8, %esp 
   
    push %esi
    push %eax
    call strcat
    add $8, %esp 
/*
    pushl %eax
    pushl $format
    call printf
    addl $4, %esp
    pop %eax
*/
    movl %eax, %ebx
    movl $5,%eax
    movl $0,%ecx
    xorl %edx, %edx
    int $0x80
    mov %eax, descriptor

   
    mov $108, %eax              
    mov descriptor, %ebx
    mov $fileInfo, %ecx          
    int $0x80                  

    mov %ebx, %eax              
    mov $255, %ecx             
    xor %edx, %edx              
    div %ecx                    
    add $1, %edx  
    mov %edx, descriptor              

    
    mov fileInfo + 20, %eax     
    xor %edx, %edx             
    mov $1024, %ecx            
    div %ecx                  
    mov %eax, size

   
    push size 
    push descriptor
    push $printf_format
    call printf
    add $12, %esp

    jmp concrete

skip_entry:
    mov stack, %esp

    pop %ebp
    pop %edi
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax

    subl $10, %esi             
    movzwl 4(%esi), %ecx       
    addl %ecx, %esi            
    cmp %ebx, %esi             
    jae read_dir               
    jmp process_entry

close_dir:
    movl $6, %eax             
    movl %edi, %ebx
    int $0x80

    pop %ecx
    inc %ecx
    jmp loop_T

concrete:
verif_descriptor:
    forC_lines:
    movl lineIndex, %ecx
    cmpl %ecx, N
    je concrete_ret

    movl $0, columnIndex
    forC_columns:
        movl columnIndex, %ecx
        cmpl %ecx, N
        je forC_lines_cont

        mov $mat, %esi
        mov lineIndex, %eax
        mull N
        add columnIndex, %eax
        movl (%esi, %eax, 4), %edx /*mat[i][j]*/ 
        
        cmp %edx, descriptor
        je concrete_X_ret
    
    forC_columns_cont:
        addl $1, columnIndex
        jmp forC_columns

    forC_lines_cont:
        addl $1, lineIndex
        jmp forC_lines  

concrete_X_ret:
    movl $1, n
    xor %ecx, %ecx
    push %ecx
    jmp add_ret_Xafis

concrete_ret:
    movl $1, n
    xor %ecx, %ecx
    push %ecx
    jmp conc_add

/*------------------------------------------------------------ */

et_exit:
    pushl $0
    call fflush
    popl %eax
    
    mov $1, %eax
    xor %ebx, %ebx
    int $0x80
