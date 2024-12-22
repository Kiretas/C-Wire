#ifndef CONSUMER_SORT_H
#define CONSUMER_SORT_H

typedef struct consumer_struct {                    //Declaration of consumer structure
    long int idstation;
    long int capa;
    long int conso;
    long int charge;
    int eq;
    struct consumer_struct* fg;
    struct consumer_struct* fd;
} Consumer;

Consumer* BuilderConsumer(long int identstation, long int capacite, long int cons, long int chargee);
void IHaveBecomeDeathDestrotyerOfWorlds(Consumer* a);
void printConsumer(const Consumer* a);

#endif
