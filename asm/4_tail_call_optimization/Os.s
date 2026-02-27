factorial_tail:
        mov     eax, esi
.L3:
        test    edi, edi
        jle     .L4
        imul    eax, edi
        dec     edi
        jmp     .L3
.L4:
        ret
