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
