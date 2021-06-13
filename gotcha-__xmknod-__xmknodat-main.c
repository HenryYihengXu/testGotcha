#include "gotcha-__xmknod-__xmknodat-wrapper.h"
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    int result;
    result = __xmknod___xmknodat_gotcha_init();
    if (result != 0) {
        return -1;
    }
    mknod("/g/g92/xu23/summer-2021/testGotcha/test/a", S_IFREG, 0);
    mknodat(1, "/g/g92/xu23/summer-2021/testGotcha/test/a", S_IFREG, 0);
    return 0;
}
