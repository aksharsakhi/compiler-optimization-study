pre_example:
        imul    esi, edx
        xor     eax, eax
.L2:
        cmp     ecx, eax
        jle     .L7
        lea     edx, [rsi+rax]
        cmp     ecx, 10
        cmovle  edx, eax
        mov     DWORD PTR [rdi+rax*4], edx
        inc     rax
        jmp     .L2
.L7:
        ret
