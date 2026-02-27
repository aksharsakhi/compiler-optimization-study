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
