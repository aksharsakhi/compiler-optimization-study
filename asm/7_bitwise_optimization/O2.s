.LC0:
        .string "Flags set correctly!"
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        call    puts
        xor     eax, eax
        add     rsp, 8
        ret
