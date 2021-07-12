
typedef struct Singleton {
    static Singleton_t *instance;
    static Singleton_t *getInstance() {
        if (instance == nullptr) {
            instance = new Singleton_t;
        }
        return instance;
    } 
    char sharedData[256];
    int counter;    
} Singleton_t;
