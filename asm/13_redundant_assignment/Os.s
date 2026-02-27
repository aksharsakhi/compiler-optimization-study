.LC0:
        .string "i = %d. x = %d.\n"
main:
        push    rax
        mov     rdi, QWORD PTR stdout[rip]
        mov     edx, 1
        xor     eax, eax
        mov     ecx, 1
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        pop     rdx
        ret
