pre_example:
        test    ecx, ecx
        jle     .L1
        imul    edx, esi
        movsx   rsi, ecx
        mov     eax, 0
.L5:
        lea     r8d, [rdx+rax]
        cmp     ecx, 10
        cmovle  r8d, eax
        mov     DWORD PTR [rdi+rax*4], r8d
        add     rax, 1
        cmp     rax, rsi
        jne     .L5
.L1:
        ret
