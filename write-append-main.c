#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <dlfcn.h>


// ssize_t write (int fd, const void *buf, size_t count) {
//     printf("In executable write wrapper\n");
//     typeof(&write) __real_fwrite = dlsym(RTLD_NEXT, "write");
//     return __real_fwrite(fd, buf, count);
// }

int main() {
    // int fd = open("./a.txt", O_APPEND);
    int fd = open("./a.txt", O_CREAT | O_RDWR | O_APPEND, S_IRWXU);
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

