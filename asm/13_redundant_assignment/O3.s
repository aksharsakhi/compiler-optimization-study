.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        xor     eax, eax
        mov     rdi, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        add     rsp, 8
        ret
