factorial_tail:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-4], edi
        mov     DWORD PTR [rbp-8], esi
        cmp     DWORD PTR [rbp-4], 0
        jg      .L2
        mov     eax, DWORD PTR [rbp-8]
        jmp     .L3
.L2:
        mov     eax, DWORD PTR [rbp-4]
        imul    eax, DWORD PTR [rbp-8]
        mov     edx, DWORD PTR [rbp-4]
        sub     edx, 1
        mov     esi, eax
        mov     edi, edx
        call    factorial_tail
.L3:
        leave
        ret
