compute_complex.constprop.0:
        mov     eax, 15
        ret
compute_complex:
        imul    eax, edi, 100
        add     edi, 5
        cmp     esi, 10
        cmovle  eax, edi
        ret
wrapper:
        mov     eax, 15
        ret
