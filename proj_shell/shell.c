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
void parseAndExecute(char* inputString, int* numberOfChildProcesses);

int main(int argc, char *argv[])
{
    /** If argc is zero, interactive mode, else batch mode. */
    if (argc == 1) {
        if (DEBUGGING) {
            printf("Mode: Interactive\n");
        }

        readInstruction(STDIN_FILEPATH); 

    } else {
        if (DEBUGGING) {
            printf("Mode: Batch\n");
        }

        for (int i = 1; i < argc; ++i) {
            readInstruction(argv[i]);
        }
    }

    return 0;
}

void readInstruction(const char* filePath){
    /** Read file to the end. */
    FILE* fp = fopen(filePath, "r");
    
    bool interactiveMode = false;
    if(strncmp(STDIN_FILEPATH, filePath, sizeof(STDIN_FILEPATH) / sizeof(char)) == 0) {
        interactiveMode = true;
    }

    char* strBuffer = (char*)calloc(STR_BUFF_SIZE, sizeof(char));
    assert(strBuffer != NULL);
    
    /** Parse strings and run the process using fork(). */
    while (!feof(fp)) {
        /** infinite loop */
        if (interactiveMode) {
            printf("prompt> ");
        }

        if ( fgets(strBuffer, STR_BUFF_SIZE, fp) != NULL ) {
            /** fgets catches '\n' */
            /** Parse user inputs and run the process using fork(). */

            if (interactiveMode == false) {
                // batch mode
                printf("%s", strBuffer);
            }

            int numberOfChildProcesses = 0;
            parseAndExecute(strBuffer, &numberOfChildProcesses);

            // run child processes simultaneously
            for (int i = 0; i < numberOfChildProcesses; ++i) {
                wait(NULL);
            }

            memset(strBuffer, 0, STR_BUFF_SIZE);
        } else {
            /* end of the file */
            if (interactiveMode) {
                if (DEBUGGING) {
                    printf("\nProgram terminated\n");
                }
                exit(EXIT_FAILURE);
            } else {
                // do nothing.
                // next while loop, while loop ends.
            }
        }
    }

    free(strBuffer);
}

void parseAndExecute(char* inputString, int* numberOfChildProcesses) {
    // statement is partitioned by ';'.
    // statement is composed of programPath and options.

    char statement[STR_BUFF_SIZE];
    int statementIdx = 0;

    char programPath[STR_BUFF_SIZE];
    int programPathIdx = 0;

    char options[STR_BUFF_SIZE];
    int optionsIdx = 0;

    while (*inputString != '\n' && *inputString != '\0') {
        //parse inputString to statements.
        memset(statement, '\0', STR_BUFF_SIZE);
        statementIdx = 0;
        while( *inputString != ';' && *inputString != '\n' && *inputString != '\0') {
            statement[statementIdx++] = *inputString;
            inputString++;
        }
        inputString++; // *inputString is ';' so increment 1.

        //parse statements to programPath and options.
        memset(programPath, '\0', STR_BUFF_SIZE);
        programPathIdx= 0;
        memset(options, '\0', STR_BUFF_SIZE);
        optionsIdx = 0;

        // programPath
        statementIdx = 0;

        //remove space before the programPath
        while (statement[statementIdx] == ' ') {
            //do nothing;
            statementIdx++;
        }
        while(statement[statementIdx] != ' ' && statement[statementIdx] != '\0') {
            programPath[programPathIdx++] = statement[statementIdx++];
        }

        // options
        while(statement[statementIdx] != '\0') {
            options[optionsIdx++] = statement[statementIdx++];
        }

        if (DEBUGGING) {
            printf("programPath: %s, options: %s\n", programPath, options);
        }

        // options Tokenization
        char* optionArgsToken;
        const char delimitor[2] = " ";

        // get the first token
        optionArgsToken = strtok(options, delimitor);

        int numberOfOptionArgs = 2;
        char** optionArgs = (char**)calloc(numberOfOptionArgs, sizeof(char*));
        assert(optionArgs != NULL);

        int optionArgsIdx = 0;
        /** strncpy(optionArgs[optionArgsIdx++], programPath, programPathIdx); */
        optionArgs[optionArgsIdx++] = programPath;
        optionArgs[optionArgsIdx++] = optionArgsToken;

        while (optionArgsToken != NULL) {
            // allocated memory is not enough, reallocate.
            if (numberOfOptionArgs == optionArgsIdx) {
                numberOfOptionArgs *= 2;
                optionArgs = (char**)realloc(optionArgs, numberOfOptionArgs * sizeof(char*));
                assert(optionArgs != NULL);
            }

            optionArgsToken = strtok(NULL, delimitor);
            optionArgs[optionArgsIdx++] = optionArgsToken;
        }
        optionArgsIdx--; // 

        if (DEBUGGING) {
            printf("Token: %s", optionArgs[1]);
            for (int i = 2; i < optionArgsIdx; ++i) {
                printf(", %s", optionArgs[i]);
            }
            putchar('\n');
        }

        // if "quit" is inputted, exit the program.
        if (strncmp(programPath, "quit", sizeof("quit")) == 0) {
            exit(0);
        }

        // fork and execute
        if (fork() == 0) {
            /** child proess */
            execvp(programPath, optionArgs);
        } else {
            /** parent process */
            (*numberOfChildProcesses)++;
        }
        free(optionArgs);
    }

}
