
/* Declaration of Macros */
%{
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
%}

%x COMMENT_SINGLE_LINE
%x COMMENT_MULTI_LINE
%option noyywrap

KEYWORD "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
DIGIT   [0-9]
ALPHABET [a-zA-Z_]

DIGIT_SEQUENCE {DIGIT}+

IDENTIFIER {ALPHABET}(({ALPHABET}|{DIGIT})*)
INTEGER_CONSTANT ([1-9]{DIGIT}*)|[0]

FRACTIONAL_CONSTANT {DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE}|{DIGIT_SEQUENCE}\.
EXPONENT_CONSTANT [eE]([+-]?){DIGIT_SEQUENCE}
FLOATING_CONSTANT {FRACTIONAL_CONSTANT}({EXPONENT_CONSTANT}?)|{DIGIT_SEQUENCE}{EXPONENT_CONSTANT}

ENUMERATION_CONSTANT {IDENTIFIER}

ESCAPE_SEQUENCE \\['"?\\abfnrtv]
C_CHAR [^\'\\\n]|{ESCAPE_SEQUENCE}
CHARACTER_CONSTANT              \'({C_CHAR}+)\'

S_CHAR                          [^\"\\\n]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE                 {S_CHAR}+

STRING_LITERAL                  \"({S_CHAR_SEQUENCE})*\"

PUNCTUATOR                      "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
WS      [ \t]
NEWLINE [\n]                

%%

{KEYWORD} {return KEYWORD;}
{IDENTIFIER} {return IDENTIFIER;}
{PUNCTUATOR} {return PUNCTUATOR;}
{INTEGER_CONSTANT} {return INTEGER_CONSTANT;}

{FLOATING_CONSTANT} {return FLOATING_CONSTANT;}
{CHARACTER_CONSTANT} {return CHARACTER_CONSTANT;}
{STRING_LITERAL} {return STRING_LITERAL;}
{WS} {}

"/*"     {BEGIN(COMMENT_MULTI_LINE); return COMMENT_MULTI_LINE_START;}
<COMMENT_MULTI_LINE>. {}
<COMMENT_MULTI_LINE>\n {}
<COMMENT_MULTI_LINE>"*/" {BEGIN(INITIAL); return COMMENT_MULTI_LINE_END;}

"//" {BEGIN(COMMENT_SINGLE_LINE); return COMMENT_SINGLE_LINE_START;}
<COMMENT_SINGLE_LINE>.          {}
<COMMENT_SINGLE_LINE>\n         { BEGIN(INITIAL); return COMMENT_SINGLE_LINE_END; }
<COMMENT_SINGLE_LINE><<EOF>>    { BEGIN(INITIAL); return COMMENT_SINGLE_LINE_END; }

{NEWLINE} {return NEWLINE;}
%%