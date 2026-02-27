.LC0:
        .string "Value is %d.\n"
main:
        sub     rsp, 8
        mov     esi, 3
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        call    printf
        xor     eax, eax
        add     rsp, 8
        ret
