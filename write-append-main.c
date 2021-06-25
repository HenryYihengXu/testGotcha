#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>

int main() {
    // int fd = open("./a.txt", O_APPEND);
    int fd = open("./a.txt", O_RDWR | O_APPEND);
    if (fd == -1) {
        printf("open returned %d, errno: %d\n", fd, errno);
    }
    char* buf = "aaaaaaaaa\n";
    int ret = write(fd, buf, 10);
    if (ret == -1) {
        printf("write returned %d, errno: %d\n", ret, errno);
    }
    return 0;
}
