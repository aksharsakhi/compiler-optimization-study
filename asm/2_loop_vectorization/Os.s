transform_data:
        mov     ecx, edx
        xor     eax, eax
.L2:
        cmp     ecx, eax
        jle     .L5
        mov     edx, DWORD PTR [rsi+rax*4]
        sal     edx, 2
        mov     DWORD PTR [rdi+rax*4], edx
        inc     rax
        jmp     .L2
.L5:
        ret
