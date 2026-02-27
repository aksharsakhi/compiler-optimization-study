void transform_data(int *restrict a, int *restrict b, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = b[i] * 4;
    }
}
