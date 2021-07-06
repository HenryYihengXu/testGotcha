#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <pthread.h>
 
typedef struct Singleton {
    char sharedData[256];
    int counter;    
} Singleton_t;
 
static Singleton_t * singleton = NULL;
static pthread_mutex_t lock;
 
Singleton_t *getInstance(){
 
    pthread_mutex_lock(&lock);
    if(singleton != NULL) {
        pthread_mutex_unlock(&lock);
        return singleton;
    } else {
        singleton = (Singleton_t *)malloc(sizeof(Singleton_t));
        assert(singleton != NULL);
        pthread_mutex_unlock(&lock);
        return singleton;
    }
}
 
int main(){
 
    omp_set_num_threads(20);
 
    id * i1, *i2;
 
    omp_init_lock(&lock);
    #pragma omp parallel
    {
        i1 = getInstance() ;
        i1->name = "Rong";
        i1->score = omp_get_thread_num();
    }
    #pragma omp parallel 
    {
        i2 = getInstance() ;
        i2->name = "Tao";
    }
    omp_destroy_lock(&lock);
 
    if(i1 == i2)
        fprintf(stdout, " i1 == i2 \n");
 
    fprintf(stdout, "i1->name = %s, i1->score = %d\n",i1->name, i1->score);
    fprintf(stdout, "i2->name = %s, i2->score = %d\n",i2->name, i2->score);
 
    return 0 ;
