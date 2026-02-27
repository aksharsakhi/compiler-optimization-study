# Compiler Design
# Case Study on Optimization Techniques

**Roll No 1 – CB.SC.U4CSE23535 (Aadesh)**  
**Roll No 2 – CB.SC.U4CSE23547 (Akshar Sakhi)**  
**Roll No 3 – CB.SC.U4CSE23538 (Nishanth)**  

---

## Introduction -

A compiler basically takes the code we write and translates it into machine code that the computer can actually run. It does this in three main steps:

1. **Frontend:** This part scans the code line by line, breaks it down into tokens, and checks if it follows the grammar rules of the language. It also checks for things like type mismatches. After making sure there are no errors, it converts the code into an Intermediate Representation (IR).
2. **Optimizer:** This is where the magic happens. The optimizer takes the IR code and improves it. It doesn't change what the program does, but it makes it run faster and use less memory.
3. **Backend:** Finally, this part takes that optimized code and turns it into the actual assembly code that tells the processor exactly what to do.

**The phase ‘Optimizer’:**
The optimizer is super important because poor code can end up running really slowly. When we write high-level code, we often focus on readability, which might introduce extra operations or unneeded math steps. The optimizer acts as a filter that cleans this up. It checks if there are variables that are never used, loops that can be shortened, or math that can be calculated ahead of time. This saves the CPU from wasting time on redundant tasks when the program actually runs.

---

## Different Techniques of optimization:

1. **Loop Unrolling:** Sometimes looping takes more time than just repeating the instructions. The compiler will expand small loops into straight-line code to save on the overhead of checking loop conditions.
2. **Loop Vectorization & Transformation:** Identifies operations on arrays or sequences that can be processed in parallel using vector instructions (like SIMD), greatly speeding up bulk data operations.
3. **Dead Code Elimination (DCE):** The compiler scans for code that is calculated but never actually used or returned, and completely strips it out to reduce file size and execution time.
4. **Tail Call Optimization (TCO):** Converts recursive function calls that happen at the very end of a function into a flat iterative loop, saving memory by reusing the stack frame and avoiding stack overflows.
5. **Switch Statement Transformation (Jump Tables):** Converts long, sequential `switch/case` comparison blocks into a direct mathematical formula or a fast O(1) jump table when case numbers are dense.
6. **Algebraic Simplification:** Combines numerical constants and simplifies complex math equations at compile-time so the processor doesn't have to calculate them at runtime.
7. **Bitwise Optimization:** Analyzes bit-level logical operations and static shifts to compress them into minimal hardware instructions.
8. **Interprocedural Constant Propagation (IPCP):** Analyzes data flows across different function boundaries. If a function is constantly called with a static number, it optimizes the function dynamically for that specific parameter.
9. **Strength Reduction:** Replaces computationally expensive math operations (like hardware multiplication or division) with mathematically equivalent but cheaper operations (like bitwise shifts or addition).
10. **Pointer Aliasing & Load/Store Optimization:** Tracks memory addresses and pointers to avoid reading from memory repeatedly. If a pointer value is already known in a register, it skips the memory fetch entirely.
11. **Instruction Scheduling:** Reorders independent arithmetic instructions physically side-by-side so modern CPUs can process them simultaneously using parallel superscalar hardware pipelines.
12. **Partial Redundancy Elimination (PRE):** Tracks math calculations that happen inside a loop. If a calculation's result never changes during the loop, it hoists the math out of the loop so it only executes once.
13. **Redundant Assignment Elimination:** Identifies when a value is assigned to a memory address or pointer redundantly (like setting a value twice in a row without change). It simply deletes the duplicated stores.

---

## Analysis:

### 1. Loop Unrolling

**1. The original program (C):**
```c
void loop_unroll(int *a) {
    for (int i = 0; i < 4; i++) {
        a[i] = i * 2;
    }
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
loop_unroll:
        push    rbp
        mov     rbp, rsp
        mov     QWORD PTR [rbp-24], rdi
        mov     DWORD PTR [rbp-4], 0
        jmp     .L2
.L3:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        mov     edx, DWORD PTR [rbp-4]
        add     edx, edx
        mov     DWORD PTR [rax], edx
        add     DWORD PTR [rbp-4], 1
.L2:
        cmp     DWORD PTR [rbp-4], 3
        jle     .L3
        nop
        nop
        pop     rbp
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
loop_unroll:
        mov     DWORD PTR [rdi], 0
        mov     DWORD PTR [rdi+4], 2
        mov     DWORD PTR [rdi+8], 4
        mov     DWORD PTR [rdi+12], 6
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
loop_unroll:
        movdqa  xmm0, XMMWORD PTR .LC0[rip]
        movups  XMMWORD PTR [rdi], xmm0
        ret
.LC0:
        .long   0
        .long   2
        .long   4
        .long   6
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
loop_unroll:
        movdqa  xmm0, XMMWORD PTR .LC0[rip]
        movups  XMMWORD PTR [rdi], xmm0
        ret
.LC0:
        .long   0
        .long   2
        .long   4
        .long   6
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
loop_unroll:
        mov     eax, 1
        sal     rax, 33
        mov     QWORD PTR [rdi], rax
        movabs  rax, 25769803780
        mov     QWORD PTR [rdi+8], rax
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
With `-O0`, the code repeatedly loops using jump statements (`jmp`) to check the end condition over and over. However, in the `-O1` configuration, the compiler identifies the limited iterations of the loop and unrolls it entirely, writing the constant results directly into memory offsets. When moving up to `-O2`, `-O3`, and `-O4`, the compiler gets even smarter and utilizes specialized 128-bit vector registers (`xmm0`) to push all four 32-bit values into memory in one single highly efficient move (`movups`). In the size-optimized configuration (`-Os`), the compiler resorts to incredibly clever bitwise shifting tricks (`sal rax, 33` and `movabs`) to generate the identical memory sequence while consuming the absolute minimum number of instruction bytes possible.

### 2. Loop Vectorization & Transformation

**1. The original program (C):**
```c
void transform_data(int *restrict a, int *restrict b, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = b[i] * 4;
    }
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
transform_data:
        push    rbp
        mov     rbp, rsp
        mov     QWORD PTR [rbp-24], rdi
        mov     QWORD PTR [rbp-32], rsi
        mov     DWORD PTR [rbp-36], edx
        mov     DWORD PTR [rbp-4], 0
        jmp     .L2
.L3:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-32]
        add     rax, rdx
        mov     edx, DWORD PTR [rax]
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rcx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rcx
        sal     edx, 2
        mov     DWORD PTR [rax], edx
        add     DWORD PTR [rbp-4], 1
.L2:
        mov     eax, DWORD PTR [rbp-4]
        cmp     eax, DWORD PTR [rbp-36]
        jl      .L3
        nop
        nop
        pop     rbp
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
transform_data:
        test    edx, edx
        jle     .L1
        movsx   rdx, edx
        lea     rcx, [0+rdx*4]
        mov     eax, 0
.L3:
        mov     edx, DWORD PTR [rsi+rax]
        sal     edx, 2
        mov     DWORD PTR [rdi+rax], edx
        add     rax, 4
        cmp     rax, rcx
        jne     .L3
.L1:
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
transform_data:
        test    edx, edx
        jle     .L1
        movsx   rdx, edx
        xor     eax, eax
        sal     rdx, 2
.L3:
        mov     ecx, DWORD PTR [rsi+rax]
        sal     ecx, 2
        mov     DWORD PTR [rdi+rax], ecx
        add     rax, 4
        cmp     rax, rdx
        jne     .L3
.L1:
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
transform_data:
        test    edx, edx
        jle     .L1
        lea     eax, [rdx-1]
        cmp     eax, 2
        jbe     .L8
        mov     ecx, edx
        xor     eax, eax
        shr     ecx, 2
        sal     rcx, 4
.L4:
        movdqu  xmm0, XMMWORD PTR [rsi+rax]
        pslld   xmm0, 2
        movups  XMMWORD PTR [rdi+rax], xmm0
        add     rax, 16
        cmp     rax, rcx
        jne     .L4
        mov     eax, edx
        and     eax, -4
        mov     ecx, eax
        cmp     edx, eax
        je      .L17
.L3:
        sub     edx, ecx
        cmp     edx, 1
        je      .L6
        movq    xmm0, QWORD PTR [rsi+rcx*4]
        pslld   xmm0, 2
        movq    QWORD PTR [rdi+rcx*4], xmm0
        test    dl, 1
        je      .L1
        and     edx, -2
        add     eax, edx
.L6:
        cdqe
        mov     edx, DWORD PTR [rsi+rax*4]
        sal     edx, 2
        mov     DWORD PTR [rdi+rax*4], edx
.L1:
        ret
.L17:
        ret
.L8:
        xor     ecx, ecx
        xor     eax, eax
        jmp     .L3
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
transform_data:
        mov     ecx, edx
        xor     eax, eax
.L2:
        cmp     ecx, eax
        jle     .L5
        mov     edx, DWORD PTR [rsi+rax*4]
        sal     edx, 2
        mov     DWORD PTR [rdi+rax*4], edx
        inc     rax
        jmp     .L2
.L5:
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` version, the program creates full memory load pathways (`mov`, `lea`, `add`) iteratively for every single item inside the loop, severely slowing down execution as it drags through stack space. When optimized via `-O1` and `-O2`, the compiler beautifully simplifies the pointer logic, instantly replacing multiplication with an array-indexed shift left calculation (`sal edx, 2`). However, the most drastic modification happens globally at the `-O3` and `-O4` levels. Here, the compiler entirely transforms the loop structure using Advanced Vector Extensions (AVX/SSE). It explicitly avoids handling numbers sequentially and instead utilizes `xmm0` vector registers. It loads four array integers simultaneously (`movdqu`), powerfully bit-shifts all of them in parallel in one CPU cycle (`pslld xmm0, 2`), and drops them directly into memory (`movups`). This is an explosive speed efficiency, proving the optimizer successfully converted a sluggish scalar loop strictly into a massive vectorized parallel operation. As expected, `-Os` strips this vectorization completely, reverting to a tiny conventional scalar loop structurally to ensure the binary size is as tiny as mathematically possible.

### 3. Dead Code Elimination (DCE)

**1. The original program (C):**
```c
int global_var = 0;

int dead_code_example(int x) {
    int a = x + 10;         // Potentially dead
    int b = a * 2;          // Potentially dead
    global_var = 5;         // Side effect (Cannot be deleted easily)
    b = b + 5;              // Dead (overwritten)
    b = x + 5;              // Only this 'b' matters
    
    return b; 
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
global_var:
        .zero   4
dead_code_example:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-20], edi
        mov     eax, DWORD PTR [rbp-20]
        add     eax, 10
        mov     DWORD PTR [rbp-4], eax
        mov     eax, DWORD PTR [rbp-4]
        add     eax, eax
        mov     DWORD PTR [rbp-8], eax
        mov     DWORD PTR global_var[rip], 5
        add     DWORD PTR [rbp-8], 5
        mov     eax, DWORD PTR [rbp-20]
        add     eax, 5
        mov     DWORD PTR [rbp-8], eax
        mov     eax, DWORD PTR [rbp-8]
        pop     rbp
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
dead_code_example:
        mov     DWORD PTR global_var[rip], 5
        lea     eax, [rdi+5]
        ret
global_var:
        .zero   4
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
dead_code_example:
        mov     DWORD PTR global_var[rip], 5
        lea     eax, [rdi+5]
        ret
global_var:
        .zero   4
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
dead_code_example:
        mov     DWORD PTR global_var[rip], 5
        lea     eax, [rdi+5]
        ret
global_var:
        .zero   4
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
dead_code_example:
        mov     DWORD PTR global_var[rip], 5
        lea     eax, [rdi+5]
        ret
global_var:
        .zero   4
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` version, the compiler stubbornly executes every single variable assignment sequentially on the stack structure as provided in the abstract program. This demands heavy stack offset manipulations (ex. `DWORD PTR [rbp-4]` and `[rbp-8]`). It calculates `a`, doubles it for `b`, sets the globally scoped variable, adds to `b` repeatedly, and then returns. However, all optimized compiler configurations `-O1` straight through `-Os` correctly prove the logic mathematically. The optimizer's liveness analysis recognizes that all manipulations to `a` and the initial math for `b` are overwritten and *never actually utilized to produce the final answer*. Despite destroying the dead mathematics flawlessly internally, the compiler correctly maintains the scope for `global_var` because mapping side-effects into global scopes is mandatory. The final result drastically improves output efficiency from a bulky 15 stack instructions entirely compressed natively to just two functional logic directives: update the global scope memory (`mov`) and effectively add mathematically 5 functionally to the input (`lea`). 

### 4. Tail Call Optimization (TCO)

**1. The original program (C):**
```c
int factorial_tail(int n, int accumulator) {
    if (n <= 0) return accumulator;
    // The recursive call is the very last action (Tail Call)
    return factorial_tail(n - 1, n * accumulator);
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
factorial_tail:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-4], edi
        mov     DWORD PTR [rbp-8], esi
        cmp     DWORD PTR [rbp-4], 0
        jg      .L2
        mov     eax, DWORD PTR [rbp-8]
        jmp     .L3
.L2:
        mov     eax, DWORD PTR [rbp-4]
        imul    eax, DWORD PTR [rbp-8]
        mov     edx, DWORD PTR [rbp-4]
        sub     edx, 1
        mov     esi, eax
        mov     edi, edx
        call    factorial_tail
.L3:
        leave
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
factorial_tail:
        mov     eax, esi
        test    edi, edi
        jle     .L5
        sub     rsp, 8
        imul    esi, edi
        sub     edi, 1
        call    factorial_tail
        add     rsp, 8
        ret
.L5:
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
factorial_tail:
        mov     eax, esi
        test    edi, edi
        jle     .L5
        test    dil, 1
        je      .L2
        imul    eax, edi
        sub     edi, 1
        test    edi, edi
        je      .L17
.L2:
        imul    eax, edi
        lea     edx, [rdi-1]
        imul    eax, edx
        sub     edi, 2
        jne     .L2
.L5:
        ret
.L17:
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
factorial_tail:
        mov     eax, esi
        test    edi, edi
        jle     .L5
        test    dil, 1
        je      .L2
        imul    eax, edi
        sub     edi, 1
        test    edi, edi
        je      .L17
.L2:
        imul    eax, edi
        lea     edx, [rdi-1]
        imul    eax, edx
        sub     edi, 2
        jne     .L2
.L5:
        ret
.L17:
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
factorial_tail:
        mov     eax, esi
.L3:
        test    edi, edi
        jle     .L4
        imul    eax, edi
        dec     edi
        jmp     .L3
.L4:
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` output, the program genuinely behaves recursively, pushing new stack frames and executing a heavy `call factorial_tail` for every single mathematical step. If `n` gets large, this recursive chain will inevitably crash the engine and run out of memory (stack overflow). However, the optimizer is incredibly intelligent regarding recursive "Tail" calls. From `-O2` onwards, the compiler proves that the recursion can be perfectly converted into an iterative approach. It aggressively shreds the `call` instruction and rewrites the function natively into a fast execution branch. Specifically, `-O2`, `-O3`, and `-O4` slightly unroll the loop logic, handling multiples of `imul` mathematically. Finally, `-Os` strips the complexity away and perfectly flattens it into a singular, tight, perfectly bounded iterative loop mapping instantly back through `jmp .L3`. The final result is that execution overhead vanishes completely and space complexity is natively reduced from an expanding $O(N)$ memory depth straight into a flat, constant $O(1)$ space.

### 5. Switch Statement Transformation (Jump Tables)

**1. The original program (C):**
```c
int switch_example(int color_code) {
    // Use a dense range of cases to trigger a Jump Table
    switch (color_code) {
        case 0: return 100;
        case 1: return 200;
        case 2: return 300;
        case 3: return 400;
        default: return 0;
    }
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
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
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
switch_example:
        cmp     edi, 2
        je      .L4
        jg      .L3
        mov     eax, 100
        test    edi, edi
        je      .L1
        cmp     edi, 1
        mov     eax, 200
        mov     edx, 0
        cmovne  eax, edx
        ret
.L3:
        cmp     edi, 3
        mov     eax, 400
        mov     edx, 0
        cmovne  eax, edx
        ret
.L4:
        mov     eax, 300
.L1:
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
switch_example:
        lea     edx, [rdi+1]
        xor     eax, eax
        imul    edx, edx, 100
        cmp     edi, 3
        cmovbe  eax, edx
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
switch_example:
        lea     edx, [rdi+1]
        xor     eax, eax
        imul    edx, edx, 100
        cmp     edi, 3
        cmovbe  eax, edx
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
switch_example:
        lea     eax, [rdi+1]
        xor     edx, edx
        imul    eax, eax, 100
        cmp     edi, 4
        cmovnb  eax, edx
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` execution, the compiler identically maps the switch statement down into a brute-force waterfall of individual conditional jump limits (`cmp` explicitly paired with `je` and `jg`). This natively wastes massive CPU cycles sequentially verifying every single case individually until a definitive match occurs. In the initial `-O1` sweep, it attempts to intelligently sort these checks linearly using a binary search configuration with conditional moves (`cmovne`). However, the most spectacular optimization happens from the `-O2` tier onward. Because the switch values `0, 1, 2, 3` map uniformly exactly to `100, 200, 300, 400`, the compiler deduces the underlying algebra natively as `(x + 1) * 100`. It completely strips and shreds the branch jumping layout entirely! It immediately replaces all heavy branches inherently with a purely mathematical formula: `lea edx, [rdi+1]` directly followed cleanly by `imul edx, edx, 100`. Finally, it sets a simple conditional bound array check (`cmovbe`) to instantly natively return `0` if the value violates the range natively. The bulky switch statement sequentially is completely smoothly completely dissolved mathematically into a brilliantly optimized flat, branchless, constant-time native mathematical execution! Similarly, `-Os` adopts this identical brilliant algebraic shortcut but utilizes a slightly differently constrained limit sequence (`cmp edi, 4` mapped flawlessly with `cmovnb`) cleanly mathematically minimizing structural bytes.

### 6. Algebraic Expression & Constant Folding

**1. The original program (C):**
```c
#include <stdio.h>
#include <linux/types.h>

#define BIGEDIAN

int main()
{
    // Number - 8128420482184
    __u32 tmp[2] = 
    {
#ifdef BIGEDIAN
        0x9D8BC888, 0x00000764
#else
        0x00000764, 0x8B9D8C88
#endif
    };

    __u64 *val = (__u64 *)&tmp[0];

    printf("Value is %llu.\n.", *val);

    return 0;
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
.LC0:
        .string "Value is %llu.\n."
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-16], -1651783544
        mov     DWORD PTR [rbp-12], 1892
        lea     rax, [rbp-16]
        mov     QWORD PTR [rbp-8], rax
        mov     rax, QWORD PTR [rbp-8]
        mov     rax, QWORD PTR [rax]
        mov     rsi, rax
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        leave
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
.LC0:
        .string "Value is %llu.\n."
main:
        sub     rsp, 8
        movabs  rsi, 8128721307784
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        add     rsp, 8
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
.LC0:
        .string "Value is %llu.\n."
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        movabs  rsi, 8128721307784
        call    printf
        xor     eax, eax
        add     rsp, 8
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
.LC0:
        .string "Value is %llu.\n."
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        movabs  rsi, 8128721307784
        call    printf
        xor     eax, eax
        add     rsp, 8
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
.LC0:
        .string "Value is %llu.\n."
main:
        push    rax
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        movabs  rsi, 8128721307784
        call    printf
        xor     eax, eax
        pop     rdx
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` version, the program literally follows the abstract C language logic step-by-step. It allocates a 16-byte stack frame (`sub rsp, 16`), independently stores the two 32-bit integer pieces (`0x9D8BC888` mapped to `-1651783544` and `0x00000764` mapped to `1892`) directly into memory at `rbp-16` and `rbp-12`. Finally, it executes slow pointer-aliasing, reloading the raw memory address back into registers just to execute the `printf` evaluation. However, the optimizer evaluates this data algorithm internally. At `-O1`, the compiler realizes that the two fixed 32-bit components actually mathematically reconstruct a singular, static 64-bit integer literal. It completely mathematically obliterates the arrays and the pointers natively! It merges the two explicit halves at compile time and perfectly calculates the absolute 64-bit constant: `8128721307784` (which perfectly aligns with the hex structures). The `-O1` through `-O3` levels instantaneously pass this computed constant directly into the `rsi` register using a highly efficient hardware push (`movabs rsi, 8128721307784`), totally bypassing memory and pointers entirely! Furthermore, `-O2` and `-O3` optimize the instruction length mathematically by utilizing a fast `xor eax, eax` operation (to clear the float-register counters) instead of utilizing the slower `mov eax, 0`. Finally, `-Os` adopts this identical structure but shrinks the stack layout logically by utilizing a single `push rax` and `pop rdx`, rather than allocating empty overhead bytes `sub rsp, 8`.

### 7. Bitwise Optimization & Constant Folding

**1. The original program (C):**
```c
#include <stdio.h>
#include <linux/types.h>

#define FLAG_ONE 1 << 0;
#define FLAG_TWO 1 << 1;
#define FLAG_THREE 1 << 2;
#define COMBINED 0x07

int main()
{
    __u32 flags = 0;
    
    flags |= FLAG_ONE;
    flags |= FLAG_TWO;
    flags |= FLAG_THREE;

    if ((flags & COMBINED) == COMBINED)
    {
        printf("Flags set correctly!\n");
    }

    return 0;
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
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
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
.LC0:
        .string "Flags set correctly!"
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        call    puts
        mov     eax, 0
        add     rsp, 8
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
.LC0:
        .string "Flags set correctly!"
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        call    puts
        xor     eax, eax
        add     rsp, 8
        ret
```

**5. The The assembly code of the optimized program (with -O3 option):**
```assembly
.LC0:
        .string "Flags set correctly!"
main:
        sub     rsp, 8
        mov     edi, OFFSET FLAT:.LC0
        call    puts
        xor     eax, eax
        add     rsp, 8
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
.LC0:
        .string "Flags set correctly!"
main:
        push    rax
        mov     edi, OFFSET FLAT:.LC0
        call    puts
        xor     eax, eax
        pop     rdx
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` execution, the compiler maps the bitwise operations sequentially and explicitly into memory. It initializes the `DWORD PTR [rbp-4]` at `0`, then individually performs the three mathematical logical `or` bit-flags (`1`, `2`, and `4`). Next, it copies this generated value back into the `eax` register, executes an `and eax, 7` to mask against the `COMBINED` limit, manually runs a `cmp eax, 7` check, and conditionally jumps based on the result. It forces the CPU to evaluate absolutely every conditional logic step.

However, all optimized layers (`-O1` through `-Os`) instantly recognize that combining `1 | 2 | 4` statically computes to `7`. Furthermore, it recognizes that comparing `7 & 7 == 7` is a permanently true analytical constant. Because the branch is guaranteed statically to execute, the compiler aggressively completely destroys the stack loading mechanisms, variables, bit-masks, and the `if/else` jump boundaries entirely! The resulting assembly instantly jumps straight to printing the string (`call puts`), totally eliminating the conditional validation flow completely mapping a bulky 15-instruction validation straight into a bare minimum flatly executing print routine efficiently.

### 8. Interprocedural Constant Propagation (IPCP)

**1. The original program (C):**
```c
// We use 'noinline' at O0/O1 to see the call, 
// but O2/O3 will ignore this to optimize.
__attribute__((noinline))
int compute_complex(int x, int check) {
    if (check > 10) {
        return x * 100;
    }
    return x + 5;
}

int wrapper() {
    // We pass a constant '5' which is < 10.
    // O2 and O3 will realize the 'if' branch is dead.
    return compute_complex(10, 5);
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
compute_complex:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-4], edi
        mov     DWORD PTR [rbp-8], esi
        cmp     DWORD PTR [rbp-8], 10
        jle     .L2
        mov     eax, DWORD PTR [rbp-4]
        imul    eax, eax, 100
        jmp     .L3
.L2:
        mov     eax, DWORD PTR [rbp-4]
        add     eax, 5
.L3:
        pop     rbp
        ret
wrapper:
        push    rbp
        mov     rbp, rsp
        mov     esi, 5
        mov     edi, 10
        call    compute_complex
        pop     rbp
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
compute_complex:
        imul    eax, edi, 100
        add     edi, 5
        cmp     esi, 10
        cmovle  eax, edi
        ret
wrapper:
        mov     esi, 5
        mov     edi, 10
        call    compute_complex
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
compute_complex:
        imul    eax, edi, 100
        add     edi, 5
        cmp     esi, 10
        cmovle  eax, edi
        ret
wrapper:
        mov     esi, 5
        mov     edi, 10
        jmp     compute_complex
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
compute_complex.constprop.0:
        mov     eax, 15
        ret
compute_complex:
        imul    eax, edi, 100
        add     edi, 5
        cmp     esi, 10
        cmovle  eax, edi
        ret
wrapper:
        mov     eax, 15
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
compute_complex:
        imul    eax, edi, 100
        add     edi, 5
        cmp     esi, 10
        cmovle  eax, edi
        ret
wrapper:
        mov     esi, 5
        mov     edi, 10
        jmp     compute_complex
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` execution, the `wrapper` function natively allocates an entire stack frame manually, pushes the numbers `10` and `5` across function boundaries, and mechanically executes a strict function `call`. Once inside `compute_complex`, the compiler manually runs the conditional `cmp` and conditionally jumps based on the unoptimized stack logic. In `-O1`, it intelligently switches `compute_complex` to use condition-less instruction hardware boundaries mapping (`cmovle`), but still executes the bulky `call compute_complex`.

By tier `-O2` and `-Os`, the compiler completely transforms the heavy function `call` boundary into a fast, flat `jmp` optimization, stripping out the return structure entirely. However, the true mathematical beauty occurs powerfully in the `-O3` tier. Utilizing "Interprocedural Constant Propagation" (IPCP), the `-O3` optimizer flawlessly crosses the function scope boundary natively! It mathematically analyzes `wrapper`, realizes the input constraints are permanently locked at `10` and `5`, and recognizes the inner `if (check > 10)` branch will mathematically permanently fail. As a result, it completely destroys the conditional boundaries of `compute_complex` entirely and creates a customized `.constprop.0` constant propagation clone containing simply `mov eax, 15`. It then brutally re-writes `wrapper` to jump directly into the pre-calculated `mov eax, 15; ret`. The massive, dynamic cross-function validation is functionally pulverized mathematically into a singular, static, flawless 1-cycle integer execution!

### 9. Strength Reduction & Constant Folding

**1. The original program (C):**
```c
/* Performance with incrementing and dividing an 8-bit integer */
#include <stdio.h>
#include <stdint.h>

int main() {
    uint8_t value = 0;

    value += 30;
    value /= 10;

    printf("Value is %d.\n", value);

    return 0;
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
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
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
.LC0:
        .string "Value is %d.\n"
main:
        sub     rsp, 8
        mov     esi, 3
        mov     edi, OFFSET FLAT:.LC0
        mov     eax, 0
        call    printf
        mov     eax, 0
        add     rsp, 8
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
.LC0:
        .string "Value is %d.\n"
main:
        sub     rsp, 8
        mov     esi, 3
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        call    printf
        xor     eax, eax
        add     rsp, 8
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
.LC0:
        .string "Value is %d.\n"
main:
        sub     rsp, 8
        mov     esi, 3
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        call    printf
        xor     eax, eax
        add     rsp, 8
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
.LC0:
        .string "Value is %d.\n"
main:
        push    rax
        mov     esi, 3
        mov     edi, OFFSET FLAT:.LC0
        xor     eax, eax
        call    printf
        xor     eax, eax
        pop     rdx
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` code, an incredibly clever architectural concept known as "Strength Reduction" is natively visible internally within the compiler structure. The CPU absolutely hates executing actual hardware `div` instructions because they require massive amounts of clock cycles to compute absolute division boundaries. Instead of running a hardware division for `/ 10`, the unoptimized compiler replaces the division entirely with a sophisticated reciprocal multiplication approach (`mov edx, -51` identically mapped with an 8-bit `mul dl`) paired explicitly with rapid bitwise shifts (`shr ax, 8` and `shr al, 3`). This reduces the computational "strength" of the expensive division algorithm identically into a cheap scalar multiplication matrix and shifts. 

However, because the variables (`value = 0`, `+30`, `/10`) mathematically rigorously produce a static integer bound of `3`, all optimizer tiers from `-O1` strictly upward trigger an absolute Constant-Folding validation wipeout. It perfectly analyzes the entire stack operation boundary sequence logically at compile-time, explicitly eliminating the division, deleting the Strength Reduction multiplications mapped from `-O0`, and aggressively stripping the stack variable layout entirely! It maps the final solution rigidly and cleanly identically to purely `mov esi, 3` into the register, sequentially bypassing the logic completely and feeding flawlessly into the print block natively at absolute zero runtime compilation cost.

### 10. Pointer Aliasing & Load/Store Optimization

**1. The original program (C):**
```c
#include <stdio.h>

int main()
{
    int i = 1;

    int *x = &i;

    fprintf(stdout, "i = %d. x = %d.\n", i, *x);

    return 0;
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-12], 1
        lea     rax, [rbp-12]
        mov     QWORD PTR [rbp-8], rax
        mov     rax, QWORD PTR [rbp-8]
        mov     ecx, DWORD PTR [rax]
        mov     edx, DWORD PTR [rbp-12]
        mov     rax, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        mov     eax, 0
        leave
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        mov     esi, OFFSET FLAT:.LC0
        mov     rdi, QWORD PTR stdout[rip]
        mov     eax, 0
        call    fprintf
        mov     eax, 0
        add     rsp, 8
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        xor     eax, eax
        mov     rdi, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        add     rsp, 8
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        xor     eax, eax
        mov     rdi, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        add     rsp, 8
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        push    rax
        mov     rdi, QWORD PTR stdout[rip]
        mov     edx, 1
        xor     eax, eax
        mov     ecx, 1
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        pop     rdx
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` logic, the compiler respects the rigid and explicit boundaries of pointer aliasing. It dutifully stores the integer `1` inside memory mapped at `[rbp-12]`. It then separately calculates that memory address natively (`lea rax`), pushes it into pointer memory `[rbp-8]`, and actually de-references the pointer backwards structurally by executing `mov ecx, DWORD PTR [rax]` precisely to print it. It evaluates the exact memory addresses mechanically. 

At `-O1` onward, the compile-time execution is wildly optimized using "Load/Store Elimination" driven by alias analysis. Because the compiler proves structurally that nothing else alters `i` between assignment and execution, it realizes the pointer abstraction `*x` and the constant `i` are perfectly mathematically identical. It absolutely ruthlessly destroys the pointer, obliterates the address (`lea`) memory storage, drops all stack de-referencing entirely, and compresses the heavy memory flow into strictly setting the formatting registers mathematically (`mov ecx, 1` and `mov edx, 1`). Both variables natively bypass the hardware memory and run straight off absolute constants natively. Consistent with the other optimization paths, `-O2` and `-O3` apply their signature instruction-byte compression explicitly switching `mov eax, 0` for `xor eax, eax`, while `-Os` physically shrinks the stack push framework.

### 11. Instruction Scheduling

**1. The original program (C):**
```c
int scheduling_example(int a, int b, int c, int d) {
    // These two calculations are independent
    int x = a * b;
    int y = c * d;
    
    return x + y;
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
scheduling_example:
        push    rbp
        mov     rbp, rsp
        mov     DWORD PTR [rbp-20], edi
        mov     DWORD PTR [rbp-24], esi
        mov     DWORD PTR [rbp-28], edx
        mov     DWORD PTR [rbp-32], ecx
        mov     eax, DWORD PTR [rbp-20]
        imul    eax, DWORD PTR [rbp-24]
        mov     DWORD PTR [rbp-4], eax
        mov     eax, DWORD PTR [rbp-28]
        imul    eax, DWORD PTR [rbp-32]
        mov     DWORD PTR [rbp-8], eax
        mov     edx, DWORD PTR [rbp-4]
        mov     eax, DWORD PTR [rbp-8]
        add     eax, edx
        pop     rbp
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
scheduling_example:
        imul    edi, esi
        imul    edx, ecx
        lea     eax, [rdi+rdx]
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
scheduling_example:
        imul    edi, esi
        imul    edx, ecx
        lea     eax, [rdi+rdx]
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
scheduling_example:
        imul    edi, esi
        imul    edx, ecx
        lea     eax, [rdi+rdx]
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
scheduling_example:
        imul    edi, esi
        imul    edx, ecx
        lea     eax, [rdi+rdx]
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` block, the compiler strictly maps the dependency chain exactly as typed in C sequentially into the stack. It painfully loads variables into memory, independently calculates `a * b` (the first `imul`), explicitly stores the result back deeply into the stack sequentially (`DWORD PTR [rbp-4]`), completely halts to then load and compute `c * d` synchronously smoothly, explicitly drops that second result onto the stack, and finally mathematically adds them.

However, modern CPUs utilize heavily pipelined hardware capable of executing multiple non-dependent mathematical logic paths simultaneously. Starting at `-O1`, the compiler's "Instruction Scheduling" algorithm aggressively analyzes the register-dependency graphs. It structurally realizes that compiling `a * b` (`imul edi, esi`) and compiling `c * d` (`imul edx, ecx`) require completely different registers and therefore completely lack cross-dependencies dynamically. Rather than stalling mathematically over memory addresses sequentially, the `-O1` structure schedules these independent `imul` assignments tightly side-by-side mathematically. By arranging these raw multiplication operations physically back-to-back inside the assembly sequence, the hardware CPU logic will intrinsically process both simultaneous pipelines in parallel at runtime. Finally, the sum is compressed rapidly in a single continuous `lea` combination loop, entirely bypassing sequential processing bottlenecks structurally.

### 12. Partial Redundancy Elimination (PRE)

**1. The original program (C):**
```c
void pre_example(int *arr, int x, int y, int n) {
    for (int i = 0; i < n; i++) {
        // x * y is invariant, but it is inside a conditional
        if (n > 10) {
            arr[i] = (x * y) + i;
        } else {
            arr[i] = i;
        }
    }
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
pre_example:
        push    rbp
        mov     rbp, rsp
        mov     QWORD PTR [rbp-24], rdi
        mov     DWORD PTR [rbp-28], esi
        mov     DWORD PTR [rbp-32], edx
        mov     DWORD PTR [rbp-36], ecx
        mov     DWORD PTR [rbp-4], 0
        jmp     .L2
.L5:
        cmp     DWORD PTR [rbp-36], 10
        jle     .L3
        mov     eax, DWORD PTR [rbp-28]
        imul    eax, DWORD PTR [rbp-32]
        mov     ecx, eax
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-24]
        add     rax, rdx
        mov     edx, DWORD PTR [rbp-4]
        add     edx, ecx
        mov     DWORD PTR [rax], edx
        jmp     .L4
.L3:
        mov     eax, DWORD PTR [rbp-4]
        cdqe
        lea     rdx, [0+rax*4]
        mov     rax, QWORD PTR [rbp-24]
        add     rdx, rax
        mov     eax, DWORD PTR [rbp-4]
        mov     DWORD PTR [rdx], eax
.L4:
        add     DWORD PTR [rbp-4], 1
.L2:
        mov     eax, DWORD PTR [rbp-4]
        cmp     eax, DWORD PTR [rbp-36]
        jl      .L5
        nop
        nop
        pop     rbp
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
pre_example:
        test    ecx, ecx
        jle     .L1
        imul    edx, esi
        movsx   rsi, ecx
        mov     eax, 0
.L5:
        lea     r8d, [rdx+rax]
        cmp     ecx, 10
        cmovle  r8d, eax
        mov     DWORD PTR [rdi+rax*4], r8d
        add     rax, 1
        cmp     rax, rsi
        jne     .L5
.L1:
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
pre_example:
        mov     eax, ecx
        test    ecx, ecx
        jle     .L1
        movsx   rcx, ecx
        cmp     eax, 10
        jle     .L6
        imul    edx, esi
        xor     eax, eax
        xor     esi, esi
.L4:
        add     esi, edx
        mov     DWORD PTR [rdi+rax*4], esi
        lea     rsi, [rax+1]
        cmp     rsi, rcx
        je      .L1
        lea     r8d, [rdx+rsi]
        add     rax, 2
        mov     DWORD PTR [rdi+rsi*4], r8d
        cmp     rcx, rax
        je      .L1
        mov     esi, eax
        jmp     .L4
.L1:
        ret
.L6:
        xor     edx, edx
        xor     eax, eax
.L3:
        mov     DWORD PTR [rdi+rax*4], edx
        lea     rdx, [rax+1]
        cmp     rdx, rcx
        je      .L1
        add     rax, 2
        mov     DWORD PTR [rdi+rdx*4], edx
        cmp     rcx, rax
        je      .L1
        mov     edx, eax
        jmp     .L3
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
pre_example:
        test    ecx, ecx
        jle     .L1
        cmp     ecx, 10
        jg      .L3
        lea     eax, [rcx-1]
        cmp     eax, 2
        jbe     .L11
        movdqa  xmm0, XMMWORD PTR .LC0[rip]
        mov     eax, ecx
        shr     eax, 2
        movups  XMMWORD PTR [rdi], xmm0
        cmp     eax, 2
        jne     .L5
        movdqa  xmm0, XMMWORD PTR .LC1[rip]
        movups  XMMWORD PTR [rdi+16], xmm0
.L5:
        mov     eax, ecx
        and     eax, -4
        test    cl, 3
        je      .L14
.L4:
        movsx   rdx, eax
        lea     esi, [rax+1]
        mov     DWORD PTR [rdi+rdx*4], eax
        cmp     ecx, esi
        jle     .L1
        add     eax, 2
        mov     DWORD PTR [rdi+4+rdx*4], esi
        cmp     eax, ecx
        jge     .L1
        mov     DWORD PTR [rdi+8+rdx*4], eax
        ret
.L3:
        imul    edx, esi
        mov     esi, ecx
        mov     r9d, 4
        mov     rax, rdi
        shr     esi, 2
        movdqa  xmm0, XMMWORD PTR .LC0[rip]
        movd    xmm2, r9d
        sal     rsi, 4
        pshufd  xmm2, xmm2, 0
        movd    xmm4, edx
        add     rsi, rdi
.L8:
        pshufd  xmm1, xmm4, 0
        paddd   xmm1, xmm0
        add     rax, 16
        paddd   xmm0, xmm2
        movups  XMMWORD PTR [rax-16], xmm1
        cmp     rax, rsi
        jne     .L8
        mov     eax, ecx
        and     eax, -4
        test    cl, 3
        je      .L1
        lea     esi, [rdx+rax]
        mov     r8d, eax
        mov     DWORD PTR [rdi+r8*4], esi
        lea     esi, [rax+1]
        cmp     ecx, esi
        jle     .L1
        add     esi, edx
        add     eax, 2
        mov     DWORD PTR [rdi+4+r8*4], esi
        cmp     ecx, eax
        jle     .L1
        add     edx, eax
        mov     DWORD PTR [rdi+8+r8*4], edx
.L1:
        ret
.L14:
        ret
.L11:
        xor     eax, eax
        jmp     .L4
.LC0:
        .long   0
        .long   1
        .long   2
        .long   3
.LC1:
        .long   4
        .long   5
        .long   6
        .long   7
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
pre_example:
        imul    esi, edx
        xor     eax, eax
.L2:
        cmp     ecx, eax
        jle     .L7
        lea     edx, [rsi+rax]
        cmp     ecx, 10
        cmovle  edx, eax
        mov     DWORD PTR [rdi+rax*4], edx
        inc     rax
        jmp     .L2
.L7:
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the unoptimized `-O0` block, the compiler strictly follows the mathematical layout of the C implementation. It inherently checks `n > 10` inside every single looping interval dynamically. For every single iteration of the `for` loop, it executes a heavy `imul eax` (representing `x * y`) dynamically within the conditional branch, meaning the CPU is mechanically computing the exact same mathematical formula repeatedly upon every pass.

By the optimized `-O1` tier, the compiler recognizes the power of Partial Redundancy Elimination (PRE) and Loop Invariant Code Motion (LICM). It proves that `x * y` will absolutely not change across any individual loop cycle. So, it perfectly shreds that calculation from the inner loop sequence entirely, hoists it up to the very top natively (`imul edx, esi`), and strictly calculates it exactly once! Furthermore, `-O2` completely duplicates the entire `for` loop structurally depending on the initial `cmp eax, 10` boundary, fundamentally separating the `n > 10` check globally. The `-O3` tier unleashes the most spectacular pipeline modifications—aggressively vectorizing the branches dynamically via massive 128-bit `xmm0` logic channels (`paddd xmm0`), structurally wiping the array loop condition recursively using loop unraveling explicitly. Meanwhile natively, `-Os` restricts loop-unrolling to compress size but strictly maintains the mathematical PRE invariant perfectly stripped into the header.

### 13. Redundant Assignment Elimination

**1. The original program (C):**
```c
#include <stdio.h>

int main()
{
    int i = 1;

    int *x = &i;
    x = &i;

    fprintf(stdout, "i = %d. x = %d.\n", i, *x);
    
    return 0;
}
```

**2. The assembly code of the original program. (with -O0 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-12], 1
        lea     rax, [rbp-12]
        mov     QWORD PTR [rbp-8], rax
        lea     rax, [rbp-12]
        mov     QWORD PTR [rbp-8], rax
        mov     rax, QWORD PTR [rbp-8]
        mov     ecx, DWORD PTR [rax]
        mov     edx, DWORD PTR [rbp-12]
        mov     rax, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        mov     rdi, rax
        mov     eax, 0
        call    fprintf
        mov     eax, 0
        leave
        ret
```

**3. The assembly code of the optimized program (with -O1 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        mov     esi, OFFSET FLAT:.LC0
        mov     rdi, QWORD PTR stdout[rip]
        mov     eax, 0
        call    fprintf
        mov     eax, 0
        add     rsp, 8
        ret
```

**4. The assembly code of the optimized program (with -O2 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        xor     eax, eax
        mov     rdi, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        add     rsp, 8
        ret
```

**5. The assembly code of the optimized program (with -O3 option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        sub     rsp, 8
        mov     ecx, 1
        mov     edx, 1
        xor     eax, eax
        mov     rdi, QWORD PTR stdout[rip]
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        add     rsp, 8
        ret
```

**6. The assembly code of the optimized program (with -Os option):**
```assembly
.LC0:
        .string "i = %d. x = %d.\n"
main:
        push    rax
        mov     rdi, QWORD PTR stdout[rip]
        mov     edx, 1
        xor     eax, eax
        mov     ecx, 1
        mov     esi, OFFSET FLAT:.LC0
        call    fprintf
        xor     eax, eax
        pop     rdx
        ret
```

**7. Add your inference on comparing the original program with the optimized program to highlight the efficiency of optimizer part of the compiler:**
In the completely unoptimized `-O0` block, we natively see exactly how naive sequential machine translation performs. The C code strictly sets `x = &i`, and then immediately subsequently redundantly sets `x = &i` again on the exact next line. Functionally mapped inside the assembly stack memory, `-O0` literally forces the identical sequence to physically run back-to-back: `lea rax, [rbp-12]` then `mov QWORD PTR [rbp-8], rax`, instantaneously followed by duplicating the literal identical instructions `lea rax, [rbp-12]` and `mov QWORD PTR [rbp-8], rax` right after consecutively! It mechanically drops the identical unchanged pointer value twice into the exact same memory map blindly wasting CPU cycles.

But starting strictly from `-O1`, the compiler deploys "Redundant Assignment Elimination". It performs structural alias propagation mathematically and detects absolutely flawlessly that `x` was physically just assigned this identical constant address. Since there were critically no intervening programmatic states mathematically altering memory, it completely aggressively shreds and deletes the second assignment physically from the instruction set! Ultimately, much like technique 10, the compiler pushes this forward natively eliminating the entire set entirely mathematically at compile-time explicitly dropping the constant `1` dynamically directly into the print registers natively via `mov ecx, 1; mov edx, 1`!

---

## Complete Optimization Comparison Table

| Technique | O0 | O1 | O2 | O3 | Os | Status Map |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| **Dead Code Elimination (DCE)** | ❌ | ✅ | ✅ | ✅ | ✅ | `O1 = O2 = O3 = Os` |
| **Tail Call Optimization (TCO)** | ❌ | ❌ | ✅ | ✅ | ❌ | `O2 = O3` |
| **Loop Unrolling** | ❌ | ❌ | ✅ | ✅ | ❌ | `O2 = O3` |
| **Loop Vectorization** | ❌ | ❌ | ❌ | ✅ | ❌ | `O3 only` |
| **Switch Statement Transformation** | ❌ | ❌ | ✅ | ✅ | ❌ | `O2 = O3` |
| **Algebraic / Constant Folding** | ❌ | ❌ | ✅ | ✅ | ❌ | `O2 = O3` |
| **Bitwise Optimization** | ❌ | ❌ | ✅ | ✅ | ❌ | `O2 = O3` |
| **IPCP (Interprocedural Constant Propagation)** | ❌ | ❌ | ❌ | ✅ | ❌ | `O3 only` |
| **Arithmetic Strength Reduction** | ❌ | ❌ | ✅ | ✅ | ❌ | `O2 = O3` |
| **Pointer Aliasing Optimization** | ❌ | ❌ | ✅ | ✅ | ❌ | `O2 = O3` |
| **Instruction Scheduling** | ❌ | ✅ | ✅ | ✅ | ✅ | `O1 = O2 = O3 = Os` |
| **Partial Redundancy Elimination (PRE)** | ❌ | ✅ | ✅ | ✅ | ✅ | `O1 = O2 = O3 = Os` |
| **Redundant Assignment Elimination** | ❌ | ✅ | ✅ | ✅ | ✅ | `O1 = O2 = O3 = Os` |

*(Note: ✅ indicates the target optimization logic was functionally executed or successfully mapped structurally at this tier compared to earlier limits. ❌ indicates standard execution or skipped structural mapping).*

---

## Conclusion:

Throughout this incredible deep-dive compiler design study, we meticulously proved and practically evaluated 13 fundamental levels of instruction pipeline and loop optimizations natively embedded inside complex modern CPU architectures. The transformation gradients natively mapped from `-O0` up through `-O3` perfectly underscore the profound hardware capability to shred code loops dynamically, logically calculate constant abstractions universally across functions natively, flatten recursion structurally into iterative models smoothly, completely strip out redundant assignment blocks, and vector-map sequential operations beautifully over parallel superscalar channels! Evaluating the resulting memory bounds directly through `.s` assembly generated from C structures proved the monumental gap between mechanical logic execution and deep-layer machine compiler optimization logic explicitly natively.
