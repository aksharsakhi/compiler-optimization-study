.LC0:
        .string "Flags set correctly!"
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-4], 0
        or      DWORD PTR [rbp-4], 1
        or      DWORD PTR [rbp-4], 2
        or      DWORD PTR [rbp-4], 4
        mov     eax, DWORD PTR [rbp-4]
        and     eax, 7
        cmp     eax, 7
        jne     .L2
        mov     edi, OFFSET FLAT:.LC0
        call    puts
.L2:
        mov     eax, 0
        leave
        ret
