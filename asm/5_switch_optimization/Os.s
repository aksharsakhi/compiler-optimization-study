switch_example:
        lea     eax, [rdi+1]
        xor     edx, edx
        imul    eax, eax, 100
        cmp     edi, 4
        cmovnb  eax, edx
        ret
