transform_data:
        test    edx, edx
        jle     .L1
        lea     eax, [rdx-1]
        cmp     eax, 2
        jbe     .L8
        mov     ecx, edx
        xor     eax, eax
        shr     ecx, 2
        sal     rcx, 4
.L4:
        movdqu  xmm0, XMMWORD PTR [rsi+rax]
        pslld   xmm0, 2
        movups  XMMWORD PTR [rdi+rax], xmm0
        add     rax, 16
        cmp     rax, rcx
        jne     .L4
        mov     eax, edx
        and     eax, -4
        mov     ecx, eax
        cmp     edx, eax
        je      .L17
.L3:
        sub     edx, ecx
        cmp     edx, 1
        je      .L6
        movq    xmm0, QWORD PTR [rsi+rcx*4]
        pslld   xmm0, 2
        movq    QWORD PTR [rdi+rcx*4], xmm0
        test    dl, 1
        je      .L1
        and     edx, -2
        add     eax, edx
.L6:
        cdqe
        mov     edx, DWORD PTR [rsi+rax*4]
        sal     edx, 2
        mov     DWORD PTR [rdi+rax*4], edx
.L1:
        ret
.L17:
        ret
.L8:
        xor     ecx, ecx
        xor     eax, eax
        jmp     .L3
