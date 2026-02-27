dead_code_example:
        mov     DWORD PTR global_var[rip], 5
        lea     eax, [rdi+5]
        ret
global_var:
        .zero   4
