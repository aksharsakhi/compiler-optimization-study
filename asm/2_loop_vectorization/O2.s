transform_data:
        test    edx, edx
        jle     .L1
        movsx   rdx, edx
        xor     eax, eax
        sal     rdx, 2
.L3:
        mov     ecx, DWORD PTR [rsi+rax]
        sal     ecx, 2
        mov     DWORD PTR [rdi+rax], ecx
        add     rax, 4
        cmp     rax, rdx
        jne     .L3
.L1:
        ret
