#include <stdio.h>
#include <stdlib.h>
#include "consumer.h"
#include "tools.h"
#include "rotation.h"
#include "insertion.h"

Consumer* BuilderConsumer(long int identstation, long int capacite, long int cons) {                        //Create a new structures with provided informations
    Consumer* new = (Consumer*)malloc(sizeof(Consumer));
    if (new == NULL) {
        exit(1);
    }
    new->idstation = identstation;
    new->capa = capacite;
    new->conso = cons;
    new->eq = 0;
    new->fg = NULL;
    new->fd = NULL;
    return new;
}

void IHaveBecomeDeathDestrotyerOfWorlds(Consumer* a) {                                                      //Free all allocated memory in post order traversal
    if (a == NULL) {
        return;
    }
    IHaveBecomeDeathDestrotyerOfWorlds(a->fg);
    IHaveBecomeDeathDestrotyerOfWorlds(a->fd);
    free(a);
}

void printConsumer(const Consumer* a) {                                                                     //Print all data in inorder traversal
    if (a == NULL) {
        return;
    }
    printConsumer(a->fg);
    printf("%ld:%ld:%ld\n", a->idstation, a->capa, a->conso);
    printConsumer(a->fd);
}
