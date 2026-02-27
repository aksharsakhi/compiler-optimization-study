scheduling_example:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-20], edi
        mov     DWORD PTR [rbp-24], esi
        mov     DWORD PTR [rbp-28], edx
        mov     DWORD PTR [rbp-32], ecx
        mov     eax, DWORD PTR [rbp-20]
        imul    eax, DWORD PTR [rbp-24]
        mov     DWORD PTR [rbp-4], eax
        mov     eax, DWORD PTR [rbp-28]
        imul    eax, DWORD PTR [rbp-32]
        mov     DWORD PTR [rbp-8], eax
        mov     edx, DWORD PTR [rbp-4]
        mov     eax, DWORD PTR [rbp-8]
        add     eax, edx
        pop     rbp
        ret
