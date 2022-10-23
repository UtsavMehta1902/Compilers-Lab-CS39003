/*
    * Umang Singla (20CS10068)
    * Utsav Mehta (20CS10069)
*/


// Test File
enum month {Jan = 1, Feb, Mar, Apr, May, Jun, Jul, Aug, Sept, Oct, Nov, Dec};

void sayHello(){
    printf("Hello");
}

auto xyz = 12;
volatile int abc = 10;
const static int pqr = 20;
extern unsigned short mn = 30;

inline double toDouble(int x){
    return (double)x;
}

int main(){
    
    // Code to test constants and identifiers
    short signed int n = 50;        // integer constant
    enum month _month = Sept;       // enum constant
    _Bool var = 1;                  // _Bool constant
    volatile int ok = 22;           // volatile constant

    // Code to test looping statements
    while (n--)
    {
        for(int i=0;i<2;i++){
            continue;
        }
    }

    // Code to test conditional statements
    switch (n)
    {
    case 0:
        n = 10;
        break;
    
    default:
        break;
    }

    // Code to test string literals
    char s[2] = "";
    char str[] = "Testing strings\n";
    
    float f1 = 45.23;       // foating constants
    float f2 = 46.E-2;
    float f3 = 12.e-7;
    float f4 = 12E0;

    char ch = '|';

    // Code to test punctuators
    int a = 0,b = 1;
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