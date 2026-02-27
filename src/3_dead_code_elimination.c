int global_var = 0;

int dead_code_example(int x) {
    int a = x + 10;         // Potentially dead
    int b = a * 2;          // Potentially dead
    global_var = 5;         // Side effect (Cannot be deleted easily)
    b = b + 5;              // Dead (overwritten)
    b = x + 5;              // Only this 'b' matters
    
    return b; 
}
