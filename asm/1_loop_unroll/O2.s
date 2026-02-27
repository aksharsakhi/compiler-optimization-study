loop_unroll:
        movdqa  xmm0, XMMWORD PTR .LC0[rip]
        movups  XMMWORD PTR [rdi], xmm0
        ret
.LC0:
        .long   0
        .long   2
        .long   4
        .long   6
