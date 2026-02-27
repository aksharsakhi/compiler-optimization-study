.LC0:
        .string "Flags set correctly!"
main:
        push    rax
        mov     edi, OFFSET FLAT:.LC0
        call    puts
        xor     eax, eax
        pop     rdx
        ret
