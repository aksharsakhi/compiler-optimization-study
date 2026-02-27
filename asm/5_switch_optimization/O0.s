switch_example:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-4], edi
        cmp     DWORD PTR [rbp-4], 3
        je      .L2
        cmp     DWORD PTR [rbp-4], 3
        jg      .L3
        cmp     DWORD PTR [rbp-4], 2
        je      .L4
        cmp     DWORD PTR [rbp-4], 2
        jg      .L3
        cmp     DWORD PTR [rbp-4], 0
        je      .L5
        cmp     DWORD PTR [rbp-4], 1
        je      .L6
        jmp     .L3
.L5:
        mov     eax, 100
        jmp     .L7
.L6:
        mov     eax, 200
        jmp     .L7
.L4:
        mov     eax, 300
        jmp     .L7
.L2:
        mov     eax, 400
        jmp     .L7
.L3:
        mov     eax, 0
.L7:
        pop     rbp
        ret
