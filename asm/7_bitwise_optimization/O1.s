.LC0:
        .string "Flags set correctly!"
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        call    puts
        mov     eax, 0
        add     rsp, 8
        ret
