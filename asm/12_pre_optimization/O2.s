pre_example:
        mov     eax, ecx
        test    ecx, ecx
        jle     .L1
        movsx   rcx, ecx
        cmp     eax, 10
        jle     .L6
        imul    edx, esi
        xor     eax, eax
        xor     esi, esi
.L4:
        add     esi, edx
        mov     DWORD PTR [rdi+rax*4], esi
        lea     rsi, [rax+1]
        cmp     rsi, rcx
        je      .L1
        lea     r8d, [rdx+rsi]
        add     rax, 2
        mov     DWORD PTR [rdi+rsi*4], r8d
        cmp     rcx, rax
        je      .L1
        mov     esi, eax
        jmp     .L4
.L1:
        ret
.L6:
        xor     edx, edx
        xor     eax, eax
.L3:
        mov     DWORD PTR [rdi+rax*4], edx
        lea     rdx, [rax+1]
        cmp     rdx, rcx
        je      .L1
        add     rax, 2
        mov     DWORD PTR [rdi+rdx*4], edx
        cmp     rcx, rax
        je      .L1
        mov     edx, eax
        jmp     .L3
