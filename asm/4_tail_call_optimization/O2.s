factorial_tail:
        mov     eax, esi
        test    edi, edi
        jle     .L5
        test    dil, 1
        je      .L2
        imul    eax, edi
        sub     edi, 1
        test    edi, edi
        je      .L17
.L2:
        imul    eax, edi
        lea     edx, [rdi-1]
        imul    eax, edx
        sub     edi, 2
        jne     .L2
.L5:
        ret
.L17:
        ret
