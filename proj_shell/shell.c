/** Metadata
 * Author               : Kim, Myeong Jae
 * File Name            : shell.c
 * Due date             : 2017-03-27
 * Compilation Standard : c11 */

/** Design Document
 * If argc is zero, interactive mode, else batch mode.
 *
 * Parsing function is needed. It returns idx and char** and idxs of char*. Memory should be allocated before entering the function.
 *
 * in interactive mode,
 *   Read standard input infinitely. Parse user inputs and run the process using fork().
 *
 * in batch mode
 *   Read file to the end. Parse strings and run the process using fork().
 *
 * when the shell meets "quit", it terminates.*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>
#include <sys/wait.h>

#define DEBUGGING false

static const int STR_BUFF_SIZE = 512;
static const char* STDIN_FILEPATH = "/dev/fd/0";

void readInstruction(const char* filePath);
void parseAndExecute(char* instructionBuffer, int* numberOfChildProcesses);

int main(int argc, char *argv[])
{
    /** If argc is zero, interactive mode, else batch mode. */
    if (argc == 1) {
        /** interactive mode */
        readInstruction(STDIN_FILEPATH); 
    } else {
        /** batch mode for all command line arguments*/
        for (int i = 1; i < argc; ++i) {
            readInstruction(argv[i]);
        }
    }

    return 0;
}

void readInstruction(const char* filePath){
    /** Read file to the end. */
    FILE* fp = fopen(filePath, "r");
    if (fp == NULL) {
        /** file open failed. do nothing. */
        return;
    }
    
    /** if file is stdin, turn on interactiveMode. */
    bool interactiveMode = false;
    if(strncmp(STDIN_FILEPATH, filePath, sizeof(STDIN_FILEPATH) / sizeof(char)) == 0) {
        interactiveMode = true;
    }

    /** this is a buffer for reading instructions. */
    char* instructionBuffer = (char*)calloc(STR_BUFF_SIZE, sizeof(char));
    assert(instructionBuffer != NULL);
    
    /** Parse strings and run the process using fork(). */
    while (!feof(fp)) {
        if (interactiveMode) {
            printf("prompt> ");
        }

        if ( fgets(instructionBuffer, STR_BUFF_SIZE, fp) != NULL ) {
            /** fgets catches '\n' */

            /** remove '\n'. If you cannot understand below, learn how strtok() works. */
            strtok(instructionBuffer, "\n");

            /** print instruction when batch mode. */
            if (interactiveMode == false) {
                /** batch mode */
                printf("%s\n", instructionBuffer);
            }

            /** Parse user inputs and run the process using fork(). */
            int numberOfChildProcesses = 0;
            parseAndExecute(instructionBuffer, &numberOfChildProcesses);

            /** run child processes simultaneously */
            for (int i = 0; i < numberOfChildProcesses; ++i) {
                wait(NULL);
            }

            memset(instructionBuffer, 0, STR_BUFF_SIZE);
        } else {
            /* end of the file */
            if (interactiveMode) {
                if (DEBUGGING) {
                    printf("\nProgram terminated\n");
                }
                exit(EXIT_FAILURE);
            } else {
                /** do nothing.
                  * next while loop, loop ends. */
            }
        }
    }

    free(instructionBuffer);
}

void parseAndExecute(char* inputString, int* numberOfChildProcesses) {
    /** Parse user inputs and run the process using fork(). */

    /** statement is partitioned by ';'.
      * statement is composed of programPath and options. */

    /** statement tokenization start */
    int numberOfStatements = 1;
    int statementArgsIdx = 0;
    char** statementArgs = (char**)calloc(numberOfStatements, sizeof(char*));
    assert(statementArgs != NULL);

    char* statementArgsToken;
    const char delimitorOfStatement[2] = ";";

    /** get the first token */
    statementArgsToken = strtok(inputString, delimitorOfStatement);
    if (statementArgsToken == NULL) {
        /** no program path. */
        return;
    }

    /** first statement */
    statementArgs[statementArgsIdx++] = statementArgsToken; 

    while (true) {
        statementArgsToken = strtok(NULL, delimitorOfStatement);

        /** no token */
        if (statementArgsToken == NULL) {
            /** end of the loop. */
            break;
        }

        /** if the allocated memory is not enough, reallocate. */
        if (numberOfStatements == statementArgsIdx) {
            numberOfStatements *= 2;
            statementArgs = (char**)realloc(statementArgs, numberOfStatements * sizeof(char*));
            assert(statementArgs != NULL);
        }

        /** add a token to tokenArray */
        statementArgs[statementArgsIdx++] = statementArgsToken;
    }

    if (DEBUGGING) {
        for (int i = 0; i < statementArgsIdx; ++i) {
            printf("statement %d: %s\n", i, statementArgs[i]);
        }
    }

    /** for every statment */
    for (int i = 0; i < statementArgsIdx; ++i) {
        /** remove spacebar before the programPath */
        while ( *(statementArgs[i]) == ' ') {
            statementArgs[i]++;
        }

        if (DEBUGGING) {
            printf("statement: %s\n", statementArgs[i]);
        }

        /** optionArgs intialization */
        int numberOfOptionArgs = 1;
        int optionArgsIdx = 0;
        char** optionArgs = (char**)calloc(numberOfOptionArgs, sizeof(char*));
        assert(optionArgs != NULL);

        /** options Tokenization start */
        char* optionArgsToken;
        const char delimitorOfOptions[2] = " ";

        /** get the first token */
        optionArgsToken = strtok(statementArgs[i], delimitorOfOptions);
        if (optionArgsToken == NULL) {
            /** no program path. */
            return;
        }

        /** optionArgs[0] is program path. */
        optionArgs[optionArgsIdx++] = optionArgsToken; 

        while (true) {
            optionArgsToken = strtok(NULL, delimitorOfOptions);

            /** no token */
            if (optionArgsToken == NULL) {
                /** end of the loop. */
                break;
            }

            /** if the allocated memory is not enough, reallocate. */
            if (numberOfOptionArgs == optionArgsIdx) {
                numberOfOptionArgs *= 2;
                optionArgs = (char**)realloc(optionArgs, numberOfOptionArgs * sizeof(char*));
                assert(optionArgs != NULL);
            }

            /** add a token to tokenArray */
            optionArgs[optionArgsIdx++] = optionArgsToken;
        }

        if (DEBUGGING) {
            printf("Token: %s", optionArgs[0]);
            for (int i = 1; i < optionArgsIdx; ++i) {
                printf(", %s", optionArgs[i]);
            }
            putchar('\n');
        }

        if (optionArgs[0] == NULL) {
            /** no program path. do nothing. */
            continue;
        }

        /** if "quit" is inputted, exit the program. */
        if (strncmp(optionArgs[0], "quit", sizeof("quit")) == 0) {
            exit(0);
        }

        /** fork and execute */
        if (fork() == 0) {
            /** child proess */
            execvp(optionArgs[0], optionArgs);
        } else {
            /** parent process */
            (*numberOfChildProcesses)++;
        }
        free(optionArgs);
    }
    free(statementArgs);
}
