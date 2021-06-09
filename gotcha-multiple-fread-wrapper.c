#include "gotcha/gotcha_types.h"
#include "gotcha/gotcha.h"
#include "gotcha-multiple-fread-wrapper.h"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

static gotcha_wrappee_handle_t wrappee_fread_handle1;
static gotcha_wrappee_handle_t wrappee_fread_handle2;
size_t gotcha_fread_wrapper1(void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t gotcha_fread_wrapper2(void *ptr, size_t size, size_t nmemb, FILE *stream);
struct gotcha_binding_t fread_wrap_actions1 [] = {
    {"fread", gotcha_fread_wrapper1, &wrappee_fread_handle1}
};
struct gotcha_binding_t fread_wrap_actions2 [] = {
    {"fread", gotcha_fread_wrapper2, &wrappee_fread_handle2}
};

int fread_init() {
    gotcha_set_priority("wrapper1", 3);
    gotcha_set_priority("wrapper2", 2);

    enum gotcha_error_t result; 
    result = gotcha_wrap(fread_wrap_actions1, sizeof(fread_wrap_actions1)/sizeof(struct gotcha_binding_t), "wrapper1");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    result = gotcha_wrap(fread_wrap_actions2, sizeof(fread_wrap_actions2)/sizeof(struct gotcha_binding_t), "wrapper2");
    if (result != GOTCHA_SUCCESS) {
      fprintf(stderr, "gotcha_wrap returned %d\n", (int) result);
      return -1;
    }
    
}

char *recover_filename(FILE *f)
{
    char fd_path[256];
    int fd = fileno(f);
    sprintf(fd_path, "/proc/self/fd/%d", fd);
    char *filename = malloc(256);
    int n;
    if ((n = readlink(fd_path, filename, 255)) < 0)
        return NULL;
    filename[n] = '\0';
    return filename;
}

size_t gotcha_fread_wrapper1(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    char* filename = recover_filename(stream);
    printf("In fread wrapper1 reading %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fread_wrapper1) __real_fread = gotcha_get_wrappee(wrappee_fread_handle1);
    return __real_fread(ptr, size, nmemb, stream);
}

size_t gotcha_fread_wrapper2(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    char* filename = recover_filename(stream);
    printf("In fread wrapper2 reading %s\n", filename);
    //sleep(1);
    typeof(&gotcha_fread_wrapper2) __real_fread = gotcha_get_wrappee(wrappee_fread_handle2);
    return __real_fread(ptr, size, nmemb, stream);
}

