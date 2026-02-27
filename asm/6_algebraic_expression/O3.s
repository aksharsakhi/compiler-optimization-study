.LC0:
        .string "Value is %llu.\n."
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        movabs  rsi, 8128721307784
        call    printf
        xor     eax, eax
        add     rsp, 8
        ret
