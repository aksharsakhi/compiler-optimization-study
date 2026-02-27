void loop_unroll(int *a) {
    for (int i = 0; i < 4; i++) {
        a[i] = i * 2;
    }
}
