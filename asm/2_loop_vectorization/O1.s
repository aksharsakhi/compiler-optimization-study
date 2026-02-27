transform_data:
        test    edx, edx
        jle     .L1
        movsx   rdx, edx
        lea     rcx, [0+rdx*4]
        mov     eax, 0
.L3:
        mov     edx, DWORD PTR [rsi+rax]
        sal     edx, 2
        mov     DWORD PTR [rdi+rax], edx
        add     rax, 4
        cmp     rax, rcx
        jne     .L3
.L1:
        ret
