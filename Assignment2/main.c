#include "myl.h"

int main()
{
    printStr("\n*****\t\tTesting printStr\t*****\n\n");

    int len = printStr("This line is printed by printStr.");
    printStr("\nCharacter count in above string is: ");
    printInt(len);
    printStr("\n\n");

    printStr("*****\t\tTesting printInt\t*****\n\n");
    printStr("This integer is printed by printInt: ");
    len = printInt(-23654);
    printStr("\nCharacter count in above integer is: ");
    printInt(len);
    printStr("\n\n");

    printStr("*****\t\tTesting printFlt\t*****\n\n");
    printStr("This floating point decimal is printed by printFlt: ");
    len = printFlt(-3.04093);
    printStr("\nCharacter count in above decimal is: ");
    printInt(len);
    printStr("\n\n");
    
    printStr("*****\t\tTesting readInt\t\t*****\n\n");
    int num;
    printStr("Enter an integer: ");
    len = readInt(&num);

    if(len == OK)
    {
        printStr("This integer is read by readInt: ");
        printInt(num);
    }
    else
    {
        printStr("Error in reading integer.");
    }

    printStr("\n\n");

    printStr("*****\t\tTesting readFlt\t\t*****\n\n");
    float fnum;
    printStr("Enter a floating point decimal: ");
    len = readFlt(&fnum);

    if(len == OK)
    {
        printStr("This floating point decimal is read by readFlt: ");
        printFlt(fnum);
    }
    else
    {
        printStr("Error in reading floating point decimal.");
    }

    printStr("\n\n");
}