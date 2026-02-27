.LC0:
        .string "Value is %llu.\n."
main:
        sub     rsp, 8
        movabs  rsi, 8128721307784
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        add     rsp, 8
        ret
