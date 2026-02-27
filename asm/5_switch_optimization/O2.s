switch_example:
        lea     edx, [rdi+1]
        xor     eax, eax
        imul    edx, edx, 100
        cmp     edi, 3
        cmovbe  eax, edx
        ret
