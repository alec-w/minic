#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

int run_test(const char* test_program_name) {
    // We blindly assume that our test programs never have a file name
    // longer than 1024 bytes minus the name of the compiler executable.
    char *command = malloc(1024);

    // Build command to compile test program with our compiler, then run it and store the return code of compilation.
    snprintf(command, 1024, "bin/minic test_programs/%s >/dev/null", test_program_name);
    int result = system(command);

    free(command);

    return result;
}

int main(void) {
    DIR *test_dir = opendir("test_programs");

    if (test_dir == NULL) {
        printf("Could not open test_programs directory!");
        return 1;
    }

    int tests_run = 0, tests_passed = 0;

    struct dirent *file;
    char* file_name;
    int test_result;
    while ((file = readdir(test_dir)) != NULL) {
        file_name = file->d_name;
        if (strcmp(file_name, "..\0") == 0 || strcmp(file_name, ".\0") == 0) continue;
        test_result = run_test(file_name);

        tests_run++;
        if (test_result == 0) {
            printf("%s: OK\n", file_name);
            tests_passed++;
        } else {
            printf("%s: FAILED\n", file_name);
        }
    }
    printf("\n%d tests run, %d passed, %d failed.\n", tests_run, tests_passed, tests_run - tests_passed);

    closedir(test_dir);

    return tests_run - tests_passed;
}
