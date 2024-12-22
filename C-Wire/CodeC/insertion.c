#include <stdio.h>
#include <stdlib.h>
#include "consumer.h"
#include "tools.h"
#include "rotation.h"
#include "insertion.h"

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

//Insertion of nodes into the avl

Consumer* insertionConsumer(Consumer* a, long int idstation, long int capa, long int conso, int* h) {
    if (a == NULL) {                                                                    //If == NULL insert the node here
        *h = 1;
        return BuilderConsumer(idstation, capa, conso);
    }

    if (idstation < a->idstation) {                                                     //Inferior goes to left subtree
        a->fg = insertionConsumer(a->fg, idstation, capa, conso, h);
        *h = -*h;
    } else if (idstation > a->idstation) {                                              //Superior goes to right subtree
        a->fd = insertionConsumer(a->fd, idstation, capa, conso, h);
    } else {                                                                            //Node already exist -> add actual capacity and consumption to the one of the existing node
        *h = 0;
        a->conso += conso;
        a->capa += capa;
        return a;
    }

    if (*h != 0) {                                                                      //If balance has changed we rebalance
        a->eq += *h;
        a = equilibrerConsumer(a);
        *h = (a->eq == 0) ? 0 : 1;
    }
    return a;
}
