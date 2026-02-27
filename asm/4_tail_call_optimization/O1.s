factorial_tail:
        mov     eax, esi
        test    edi, edi
        jle     .L5
        sub     rsp, 8
        imul    esi, edi
        sub     edi, 1
        call    factorial_tail
        add     rsp, 8
        ret
.L5:
        ret
