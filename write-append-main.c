#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <fcntl.h>

int main() {
    int fd = open("./a.txt", O_CREAT, S_IRWXU);
    char* buf = "aaaaaaaaa\n";
    write(fd, buf, 10);
    return 0;
}
