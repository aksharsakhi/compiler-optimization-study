.LC0:
        .string "Value is %d.\n"
main:
        push    rax
        mov     esi, 3
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        call    printf
        xor     eax, eax
        pop     rdx
        ret
