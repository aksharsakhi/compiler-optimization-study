int scheduling_example(int a, int b, int c, int d) {
    // These two calculations are independent
    int x = a * b;
    int y = c * d;
    
    return x + y;
}
