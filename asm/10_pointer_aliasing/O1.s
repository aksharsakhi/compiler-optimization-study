.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        mov     esi, OFFSET FLAT:.LC0
        mov     rdi, QWORD PTR stdout[rip]
        mov     eax, 0
        call    fprintf
        mov     eax, 0
        add     rsp, 8
        ret
