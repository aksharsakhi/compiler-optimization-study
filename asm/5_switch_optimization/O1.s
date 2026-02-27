switch_example:
        cmp     edi, 2
        je      .L4
        jg      .L3
        mov     eax, 100
        test    edi, edi
        je      .L1
        cmp     edi, 1
        mov     eax, 200
        mov     edx, 0
        cmovne  eax, edx
        ret
.L3:
        cmp     edi, 3
        mov     eax, 400
        mov     edx, 0
        cmovne  eax, edx
        ret
.L4:
        mov     eax, 300
.L1:
        ret
