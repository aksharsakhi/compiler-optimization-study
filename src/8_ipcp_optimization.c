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
