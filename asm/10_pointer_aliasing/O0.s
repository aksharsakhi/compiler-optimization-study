.LC0:
        .string "i = %d. x = %d.\n"
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-12], 1
        lea     rax, [rbp-12]
        mov     QWORD PTR [rbp-8], rax
        mov     rax, QWORD PTR [rbp-8]
        mov     ecx, DWORD PTR [rax]
        mov     edx, DWORD PTR [rbp-12]
        mov     rax, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        mov     eax, 0
        leave
        ret
