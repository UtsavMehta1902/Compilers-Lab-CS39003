// Test File
#include <stdio.h>

typedef unsigned long long ull;

enum month {Jan = 1, Feb, Mar, Apr, May, Jun, Jul, Aug, Sept, Oct, Nov, Dec};

struct student{
    int roll_no;
};

struct node{
    int val;
    struct tree* next;
};

void sayHello(){
    printf("Hello");
}

int main(){
    // testing identifiers and constants
    short signed int n = 50;        // integer constants
    enum month _month = Sept;       // enum constants

    volatile int ook = 22;

    while (n--)
    {
        for(int i=0;i<2;i++){
            continue;
        }
    }

    switch (n)
    {
    case 0:
        n = 10;
        break;
    
    default:
        break;
    }
    

    float f1 = 23.23;       // foating constants
    float f2 = 23.E-2;
    float f3 = 23.e-2;
    float f4 = 243E3;

    char a = '%';

    // testing string literals
    char s[2] = "";
    char str[] = "This is a testing string\n";

    // testing punctuators
    int a = 1,b = 2;
    a++;
    b--;
    a = ~b;
    a = a/b;
    a = a%b;
    a /= b;
    a %= b;
    a = a^b;
    a = a|b;
    a = a*b;
    a = a+b;
    a = a-b;
    a = !b;
    a |= b, b = 0;
    a = (a&&b) ? a : b;
    a *= b;
    a &= b;
    a ^= b;
    a += b;
    a -= b;
    a <<= b;
    a >>= b;
    a = a<<b;
    a = a>>b;
    a = a&b;

    if(n<0){
        n*=-1;
    }else{
        n = 2*n;
    }

    // This is a single line comment

    /* This is a multi-line comment.
        Testing multiline comment 
    */


   return 0;

}