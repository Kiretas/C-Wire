#include <stdio.h>
#include <stdlib.h>
#include "consumer.h"
#include "tools.h"
#include "rotation.h"
#include "insertion.h"

long int max(long int a, long int b) {                      //Max between 2 numbers
    return (a > b) ? a : b;
}

long int min(long int a, long int b) {                      //Min between 2 numbers
    return (a < b) ? a : b;
}

long int max3(long int a, long int b, long int c) {         //Max between 3 numbers
    return max(max(a, b), c);
}

long int min3(long int a, long int b, long int c) {         //Min between 3 numbers
    return min(min(a, b), c);
}
