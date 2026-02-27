.LC0:
        .string "Value is %d.\n"
main:
        sub     rsp, 8
        mov     esi, 3
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        add     rsp, 8
        ret
