compute_complex:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-4], edi
        mov     DWORD PTR [rbp-8], esi
        cmp     DWORD PTR [rbp-8], 10
        jle     .L2
        mov     eax, DWORD PTR [rbp-4]
        imul    eax, eax, 100
        jmp     .L3
.L2:
        mov     eax, DWORD PTR [rbp-4]
        add     eax, 5
.L3:
        pop     rbp
        ret
wrapper:
        push    rbp
        mov     rbp, rsp
        mov     esi, 5
        mov     edi, 10
        call    compute_complex
        pop     rbp
        ret
