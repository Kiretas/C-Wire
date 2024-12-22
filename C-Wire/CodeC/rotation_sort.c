#include "rotation_sort.h"
#include "tools_sort.h"
#include <stdio.h>
#include <stdlib.h>

Consumer* rotationGauche(Consumer* a) {                                         //Left rotation of the the unbalanced node
    Consumer* pivot = a->fd;
    int eq_a = a->eq;
    int eq_p = pivot->eq;
    a->fd = pivot->fg;
    pivot->fg = a;
    a->eq = eq_a - max(eq_p, 0) - 1;
    pivot->eq = min3(eq_a - 2, eq_a + eq_p - 2, eq_p - 1);
    return pivot;
}

Consumer* rotationDroite(Consumer* a) {                                         //Right rotation of the the unbalanced node
    Consumer* pivot = a->fg;
    int eq_a = a->eq, eq_p = pivot->eq;
    a->fg = pivot->fd;
    pivot->fd = a;
    a->eq = eq_a - min(eq_p, 0) + 1;
    pivot->eq = max3(eq_a + 2, eq_a + eq_p + 2, eq_p + 1);
    return pivot;
}

Consumer* doubleRotationGauche(Consumer* a) {
    a->fd = rotationDroite(a->fd);
    return rotationGauche(a);
}

Consumer* doubleRotationDroite(Consumer* a) {
    a->fg = rotationGauche(a->fg);
    return rotationDroite(a);
}

Consumer* equilibrerConsumer(Consumer* a) {                                     
    if (a->eq >= 2) {                                                           //If the tree is unbalanced to the right
        if (a->fd->eq >= 0) {                                                   //Simple rotation
            return rotationGauche(a);
        } else {                                                                //Double rotation needed
            return doubleRotationGauche(a);
        }
    } else if (a->eq <= -2) {                                                   //If the tree is unbalanced to the left
        if (a->fg->eq <= 0) {                                                   //Simple rotation
            return rotationDroite(a);
        } else {                                                                //Double rotation needed
            return doubleRotationDroite(a);
        }
    }
    return a;
}
