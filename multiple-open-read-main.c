#include "multiple-fopen-wrapper.h"
#include "multiple-fread-wrapper.h"

int main() {
    int result;
    result = fopen_init();
    if (result != 0) {
        return -1;
    }
    result = fread_init();
    if (result != 0) {
        return -1;
    }
    FILE *f;
    f = fopen("./a.txt", "rb");
    char buf[1024];
    fread(buf, 1024, 1, f);
    return 0;
}

