/* 
    # Assignment - 3
    # Semester - 5 (AUTUMN 2022-2023)
    # Names of group numbers - Utsav Mehta (20CS10069), Umang Singla (20CS10068)
*/

#include <stdio.h>

#define KEYWORD 250
#define IDENTIFIER 251
#define INTEGER_CONSTANT 252
#define FLOATING_CONSTANT 253
#define CHARACTER_CONSTANT 254
#define STRING_LITERAL 255
#define PUNCTUATOR 256
#define COMMENT_SINGLE_LINE_START 257
#define COMMENT_SINGLE_LINE_END 258
#define COMMENT_MULTI_LINE_START 259
#define COMMENT_MULTI_LINE_END 260
#define NEWLINE 261

extern char* yytext;
extern int yylex();

int main() 
{   
    printf("\n\n"); // For better readability on terminal and output file

    int token;
    while(token = yylex()) 
    {
        switch(token) 
        {
			case COMMENT_SINGLE_LINE_START: 
                printf("<COMMENT_SINGLE_LINE_START, %d, %s> ", token, yytext);
                break;

            case COMMENT_SINGLE_LINE_END: 
                printf("<COMMENT_SINGLE_LINE_END, %d, %s> ", token, "\"\\n\"");
                break;

            case COMMENT_MULTI_LINE_START: 
                printf("<COMMENT_MULTI_LINE_START, %d, %s> ", token, yytext);
                break;

            case COMMENT_MULTI_LINE_END: 
                printf("<COMMENT_MULTI_LINE_END, %d, %s> ", token, yytext);
                break;

            case KEYWORD: 
                printf("<KEYWORD, %d, %s> ", token, yytext);
                break;

            case IDENTIFIER: 
                printf("<IDENTIFIER, %d, %s> ", token, yytext);
                break;

            case PUNCTUATOR: 
                printf("<PUNCTUATOR, %d, %s> ", token, yytext);
                break;

            case CHARACTER_CONSTANT: 
                printf("<CHARACTER_CONSTANT, %d, %s> ", token, yytext);
                break;

            case STRING_LITERAL: 
                printf("<STRING_LITERAL, %d, %s> ", token, yytext);
                break;

			case INTEGER_CONSTANT: 
                printf("<INTEGER_CONSTANT, %d, %s> ", token, yytext);
                break;

            case FLOATING_CONSTANT: 
                printf("<FLOATING_CONSTANT, %d, %s> ", token, yytext);
                break;
			
			case NEWLINE:
				printf("\n");
				break;

            default:
                printf("<INVALID_TOKEN, %s> ", yytext);
        }
    }

    printf("\n\n"); // For better readability on terminal and output file

    return 0;
}