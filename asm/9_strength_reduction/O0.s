.LC0:
        .string "Value is %d.\n"
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     BYTE PTR [rbp-1], 0
        add     BYTE PTR [rbp-1], 30
        movzx   eax, BYTE PTR [rbp-1]
        mov     edx, -51
        mul     dl
        shr     ax, 8
        shr     al, 3
        mov     BYTE PTR [rbp-1], al
        movzx   eax, BYTE PTR [rbp-1]
        mov     esi, eax
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        leave
        ret
