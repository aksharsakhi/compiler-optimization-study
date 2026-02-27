global_var:
        .zero   4
dead_code_example:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-20], edi
        mov     eax, DWORD PTR [rbp-20]
        add     eax, 10
        mov     DWORD PTR [rbp-4], eax
        mov     eax, DWORD PTR [rbp-4]
        add     eax, eax
        mov     DWORD PTR [rbp-8], eax
        mov     DWORD PTR global_var[rip], 5
        add     DWORD PTR [rbp-8], 5
        mov     eax, DWORD PTR [rbp-20]
        add     eax, 5
        mov     DWORD PTR [rbp-8], eax
        mov     eax, DWORD PTR [rbp-8]
        pop     rbp
        ret
