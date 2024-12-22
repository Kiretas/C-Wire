#include "insertion_sort.h"
#include "rotation_sort.h"
#include "stdio.h"
#include "stdlib.h"


//Insertion of nodes into the avl

Consumer* insertionConsumer(Consumer* a, long int idstation, long int capa, long int conso, long int charge, int* h) {
    if (a == NULL) {                                                //If == NULL insert the node here
        *h = 1;
        return BuilderConsumer(idstation, capa, conso, charge);
    }

    if (charge < a->charge) {                                       //Inferior goes to left subtree
        a->fg = insertionConsumer(a->fg, idstation, capa, conso, charge, h);
        *h = -*h;
    } else if (charge > a->charge) {                                //Superior goes to right subtree
        a->fd = insertionConsumer(a->fd, idstation, capa, conso, charge, h);
    } else {                                                        //Node already exist
        *h = 0;
        return a;
    }

    if (*h != 0) {                                                  //If balance has changed we rebalance
        a->eq += *h;
        a = equilibrerConsumer(a);
        *h = (a->eq == 0) ? 0 : 1;
    }
    return a;
}
