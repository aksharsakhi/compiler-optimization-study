compute_complex:
        imul    eax, edi, 100
        add     edi, 5
        cmp     esi, 10
        cmovle  eax, edi
        ret
wrapper:
        mov     esi, 5
        mov     edi, 10
        call    compute_complex
        ret
