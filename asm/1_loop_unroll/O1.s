loop_unroll:
        mov     DWORD PTR [rdi], 0
        mov     DWORD PTR [rdi+4], 2
        mov     DWORD PTR [rdi+8], 4
        mov     DWORD PTR [rdi+12], 6
        ret
