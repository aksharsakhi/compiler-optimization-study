int factorial_tail(int n, int accumulator) {
    if (n <= 0) return accumulator;
    // The recursive call is the very last action (Tail Call)
    return factorial_tail(n - 1, n * accumulator);
}
