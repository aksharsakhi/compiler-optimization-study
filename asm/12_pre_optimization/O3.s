pre_example:
        test    ecx, ecx
        jle     .L1
        cmp     ecx, 10
        jg      .L3
        lea     eax, [rcx-1]
        cmp     eax, 2
        jbe     .L11
        movdqa  xmm0, XMMWORD PTR .LC0[rip]
        mov     eax, ecx
        shr     eax, 2
        movups  XMMWORD PTR [rdi], xmm0
        cmp     eax, 2
        jne     .L5
        movdqa  xmm0, XMMWORD PTR .LC1[rip]
        movups  XMMWORD PTR [rdi+16], xmm0
.L5:
        mov     eax, ecx
        and     eax, -4
        test    cl, 3
        je      .L14
.L4:
        movsx   rdx, eax
        lea     esi, [rax+1]
        mov     DWORD PTR [rdi+rdx*4], eax
        cmp     ecx, esi
        jle     .L1
        add     eax, 2
        mov     DWORD PTR [rdi+4+rdx*4], esi
        cmp     eax, ecx
        jge     .L1
        mov     DWORD PTR [rdi+8+rdx*4], eax
        ret
.L3:
        imul    edx, esi
        mov     esi, ecx
        mov     r9d, 4
        mov     rax, rdi
        shr     esi, 2
        movdqa  xmm0, XMMWORD PTR .LC0[rip]
        movd    xmm2, r9d
        sal     rsi, 4
        pshufd  xmm2, xmm2, 0
        movd    xmm4, edx
        add     rsi, rdi
.L8:
        pshufd  xmm1, xmm4, 0
        paddd   xmm1, xmm0
        add     rax, 16
        paddd   xmm0, xmm2
        movups  XMMWORD PTR [rax-16], xmm1
        cmp     rax, rsi
        jne     .L8
        mov     eax, ecx
        and     eax, -4
        test    cl, 3
        je      .L1
        lea     esi, [rdx+rax]
        mov     r8d, eax
        mov     DWORD PTR [rdi+r8*4], esi
        lea     esi, [rax+1]
        cmp     ecx, esi
        jle     .L1
        add     esi, edx
        add     eax, 2
        mov     DWORD PTR [rdi+4+r8*4], esi
        cmp     ecx, eax
        jle     .L1
        add     edx, eax
        mov     DWORD PTR [rdi+8+r8*4], edx
.L1:
        ret
.L14:
        ret
.L11:
        xor     eax, eax
        jmp     .L4
.LC0:
        .long   0
        .long   1
        .long   2
        .long   3
.LC1:
        .long   4
        .long   5
        .long   6
        .long   7
