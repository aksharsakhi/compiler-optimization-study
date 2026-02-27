loop_unroll:
        mov     eax, 1
        sal     rax, 33
        mov     QWORD PTR [rdi], rax
        movabs  rax, 25769803780
        mov     QWORD PTR [rdi+8], rax
        ret
