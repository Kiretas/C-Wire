#include <stdio.h>
#include <stdlib.h>
#include "consumer.h"
#include "tools.h"
#include "rotation.h"
#include "insertion.h"

int main() {
    long int e1, e2, e3;                                                //Declaration of storage variables
    Consumer* p = NULL;                                                 //Create avl
    int h = 0;                                                          //Initialize ha as a balance control variable

    while ((scanf("%ld;%ld;%ld\n", &e1, &e2, &e3)) == 3) {              //Read the data from standard input
        p = insertionConsumer(p, e1, e2, e3, &h);                       //Create nodes for each line of data
    }

    printConsumer(p);                                                   //Print the analyzed data
    IHaveBecomeDeathDestrotyerOfWorlds(p);                              //Free all the allocated memory
    return 0;                                                           //End the program
}
