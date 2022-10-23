/*
    * Umang Singla (20CS10068)
    * Utsav Mehta (20CS10069)
*/

%{
    #include <stdio.h>
    extern int yylex();
    void yyerror(char *);
    extern char* yytext;
    extern int yylineno;
%}

%union {
    int intVal;
    float fVal;
    char *charVal;
    char *strVal;
    char *idVal;
}

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE BOOL COMPLEX IMAGINARY

%token LEFT_SQUARE_BRACE RIGHT_SQUARE_BRACE LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_CURLY_BRACE RIGHT_CURLY_BRACE 
%token DOT ARROW INCREMENT DECREMENT BITWISE_AND MULTIPLY ADD SUBTRACT BITWISE_NOR NOT DIVIDE MODULUS 
%token LEFT_SHIFT RIGHT_SHIFT LESS_THAN GREATER_THAN LESS_THAN_EQUAL GREATER_THAN_EQUAL EQUAL NOT_EQUAL BITWISE_XOR BITWISE_OR 
%token LOGICAL_AND LOGICAL_OR QUESTION_MARK COLON SEMICOLON ELLIPSIS 
%token ASSIGN MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULUS_ASSIGN ADD_ASSIGN SUBTRACT_ASSIGN LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN COMMA HASH

%token IDENTIFIER
%token <intval> INTEGER_CONSTANT
%token <floatval> FLOATING_CONSTANT
%token <charval> CHARACTER_CONSTANT
%token <strval> STRING_LITERAL

%nonassoc RIGHT_PARENTHESIS
%nonassoc ELSE

%start translation_unit

%%

primary_expr: IDENTIFIER
                        { printf("primary-expr => identifier\n"); }
                  | constant
                        { printf("primary-expr => constant\n"); }
                  | STRING_LITERAL
                        { printf("primary-expr => string-literal\n"); }
                  | LEFT_PARENTHESIS expr RIGHT_PARENTHESIS
                        { printf("primary-expr => ( expr )\n"); }
                  ;

argument_expr_list_opt: argument_expr_list
                                  { printf("argument-expr-list-opt => argument-expr-list\n"); }
                            |
                                  { printf("argument-expr-list-opt => epsilon\n"); }
                            ;

argument_expr_list: assignment_expr
                              { printf("argument-expr-list => assignment-expr\n"); }
                        | argument_expr_list COMMA assignment_expr
                              { printf("argument-expr-list => argument-expr-list , assignment-expr\n"); }
                        ;

unary_expr: postfix_expr
                      { printf("unary-expr => postfix-expr\n"); }
                | INCREMENT unary_expr
                      { printf("unary-expr => ++ unary-expr\n"); }
                | DECREMENT unary_expr
                      { printf("unary-expr => -- unary-expr\n"); }
                | unary_operator cast_expr
                      { printf("unary-operator => cast-expr\n"); }
                | SIZEOF unary_expr
                      { printf("unary-expr => sizeof unary-expr\n"); }
                | SIZEOF LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS
                      { printf("unary-expr => sizeof ( type-name )\n"); }
                ;

constant: INTEGER_CONSTANT
              { printf("constant => integer-constant\n"); }
        | FLOATING_CONSTANT
              { printf("constant => floating-constant\n"); }
        | CHARACTER_CONSTANT
              { printf("constant => char-constant\n"); }
        ;

postfix_expr: primary_expr
                        { printf("postfix-expr => primary-expr\n"); }
                  | postfix_expr LEFT_SQUARE_BRACE expr RIGHT_SQUARE_BRACE
                        { printf("postfix-expr => postfix-expr [ expr ]\n"); }
                  | postfix_expr LEFT_PARENTHESIS argument_expr_list_opt RIGHT_PARENTHESIS
                        { printf("postfix-expr => postfix-expr ( argument-expr-list-opt )\n"); }
                  | postfix_expr DOT IDENTIFIER
                        { printf("postfix-expr => postfix-expr . identifier\n"); }
                  | postfix_expr ARROW IDENTIFIER
                        { printf("postfix-expr => postfix-expr -> identifier\n"); }
                  | postfix_expr INCREMENT
                        { printf("postfix-expr => postfix-expr ++\n"); }
                  | postfix_expr DECREMENT
                        { printf("postfix-expr => postfix-expr --\n"); }
                  | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS LEFT_CURLY_BRACE initializer_list RIGHT_CURLY_BRACE
                        { printf("postfix-expr => ( type-name ) { initializer-list }\n"); }
                  | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS LEFT_CURLY_BRACE initializer_list COMMA RIGHT_CURLY_BRACE
                        { printf("postfix-expr => ( type-name ) { initializer-list , }\n"); }
                  ;

unary_operator: BITWISE_AND
                    { printf("unary-operator => &\n"); }
              | MULTIPLY
                    { printf("unary-operator => *\n"); }
              | ADD
                    { printf("unary-operator => +\n"); }
              | SUBTRACT
                    { printf("unary-operator => -\n"); }
              | BITWISE_NOR
                    { printf("unary-operator => ~\n"); }
              | NOT
                    { printf("unary-operator => !\n"); }
              ;

cast_expr: unary_expr
                     { printf("cast-expr => unary-expr\n"); }
               | LEFT_PARENTHESIS type_name RIGHT_PARENTHESIS cast_expr
                     { printf("cast-expr => ( type-name ) cast-expr\n"); }
               ;

multiplicative_expr: cast_expr
                               { printf("multiplicative-expr => cast-expr\n"); }
                         | multiplicative_expr MULTIPLY cast_expr
                               { printf("multiplicative-expr => multiplicative-expr * cast-expr\n"); }
                         | multiplicative_expr DIVIDE cast_expr
                               { printf("multiplicative-expr => multiplicative-expr / cast-expr\n"); }
                         | multiplicative_expr MODULUS cast_expr
                               { printf("multiplicative-expr => multiplicative-expr %% cast-expr\n"); }
                         ;

additive_expr: multiplicative_expr
                         { printf("additive-expr => multiplicative-expr\n"); }
                   | additive_expr ADD multiplicative_expr
                         { printf("additive-expr => additive-expr + multiplicative-expr\n"); }
                   | additive_expr SUBTRACT multiplicative_expr
                         { printf("additive-expr => additive-expr - multiplicative-expr\n"); }
                   ;

shift_expr: additive_expr
                      { printf("shift-expr => additive-expr\n"); }
                | shift_expr LEFT_SHIFT additive_expr
                      { printf("shift-expr => shift-expr << additive-expr\n"); }
                | shift_expr RIGHT_SHIFT additive_expr
                      { printf("shift-expr => shift-expr >> additive-expr\n"); }
                ;

relational_expr: shift_expr
                           { printf("relational-expr => shift-expr\n"); }
                     | relational_expr LESS_THAN shift_expr
                           { printf("relational-expr => relational-expr < shift-expr\n"); }
                     | relational_expr GREATER_THAN shift_expr
                           { printf("relational-expr => relational-expr > shift-expr\n"); }
                     | relational_expr LESS_THAN_EQUAL shift_expr
                           { printf("relational-expr => relational-expr <= shift-expr\n"); }
                     | relational_expr GREATER_THAN_EQUAL shift_expr
                           { printf("relational-expr => relational-expr >= shift-expr\n"); }
                     ;

equality_expr: relational_expr
                         { printf("equality-expr => relational-expr\n"); }
                   | equality_expr EQUAL relational_expr
                          { printf("equality-expr => equality-expr == relational-expr\n"); }
                   | equality_expr NOT_EQUAL relational_expr
                          { printf("equality-expr => equality-expr != relational-expr\n"); }
                   ;

and_expr: equality_expr
                    { printf("AND-expr => equality-expr\n"); }
              | and_expr BITWISE_AND equality_expr
                    { printf("AND-expr => AND-expr & equality-expr\n"); }
              ;

exclusive_or_expr: and_expr
                             { printf("exclusive-OR-expr => AND-expr\n"); }
                       | exclusive_or_expr BITWISE_XOR and_expr
                             { printf("exclusive-OR-expr => exclusive-OR-expr ^ AND-expr\n"); }
                       ;

inclusive_or_expr: exclusive_or_expr
                             { printf("inclusive-OR-expr => exclusive-OR-expr\n"); }
                       | inclusive_or_expr BITWISE_OR exclusive_or_expr
                             { printf("inclusive-OR-expr => inclusive-OR-expr | exclusive-OR-expr\n"); }
                       ;

logical_and_expr: inclusive_or_expr
                            { printf("logical-AND-expr => inclusive-OR-expr\n"); }
                      | logical_and_expr LOGICAL_AND inclusive_or_expr
                            { printf("logical-AND-expr => logical-AND-expr && inclusive-OR-expr\n"); }
                      ;

logical_or_expr: logical_and_expr
                           { printf("logical-OR-expr => logical-AND-expr\n"); }
                     | logical_or_expr LOGICAL_OR logical_and_expr
                           { printf("logical-OR-expr => logical_or_expr || logical-AND-expr\n"); }
                     ;

conditional_expr: logical_or_expr
                            { printf("conditional-expr => logical-OR-expr\n"); }
                      | logical_or_expr QUESTION_MARK expr COLON conditional_expr
                            { printf("conditional-expr => logical-OR-expr ? expr : conditional-expr\n"); }
                      ;

assignment_expr: conditional_expr
                           { printf("assignment-expr => conditional-expr\n"); }
                     | unary_expr assignment_operator assignment_expr
                           { printf("assignment-expr => unary-expr assignment-operator assignment-expr\n"); }
                     ;

assignment_operator: ASSIGN
                         { printf("assignment-operator => =\n"); }
                   | MULTIPLY_ASSIGN
                         { printf("assignment-operator => *=\n"); }
                   | DIVIDE_ASSIGN
                         { printf("assignment-operator => /=\n"); }
                   | MODULUS_ASSIGN
                         { printf("assignment-operator => %%=\n"); }
                   | ADD_ASSIGN
                         { printf("assignment-operator => +=\n"); }
                   | SUBTRACT_ASSIGN
                         { printf("assignment-operator => -=\n"); }
                   | LEFT_SHIFT_ASSIGN
                         { printf("assignment-operator => <<=\n"); }
                   | RIGHT_SHIFT_ASSIGN
                         { printf("assignment-operator => >>=\n"); }
                   | AND_ASSIGN
                         { printf("assignment-operator => &=\n"); }
                   | XOR_ASSIGN
                         { printf("assignment-operator => ^=\n"); }
                   | OR_ASSIGN
                         { printf("assignment-operator => |=\n"); }
                   ;

expr: assignment_expr
                { printf("expr => assignment-expr\n"); }
          | expr COMMA assignment_expr
                { printf("expr => expr , assignment-expr\n"); }
          ;

declaration_specifiers: storage_class_specifier declaration_specifiers_opt
                            { printf("declaration-specifiers => storage-class-specifier declaration-specifiers-opt\n"); }
                      | type_specifier declaration_specifiers_opt
                            { printf("declaration-specifiers => type-specifier declaration-specifiers-opt\n"); }
                      | type_qualifier declaration_specifiers_opt
                            { printf("declaration-specifiers => type-qualifier declaration-specifiers-opt\n"); }
                      | function_specifier declaration_specifiers_opt
                            { printf("declaration-specifiers => function-specifier declaration-specifiers-opt\n"); }
                      ;

declaration_specifiers_opt: declaration_specifiers
                                { printf("declaration-specifiers-opt => declaration-specifiers\n"); }
                          |
                                { printf("declaration-specifiers-opt => epsilon\n"); }
                          ;

init_declarator_list: init_declarator
                          { printf("init-declarator-list => init-declarator\n"); }
                    | init_declarator_list COMMA init_declarator
                          { printf("init-declarator-list => init-declarator-list , init-declarator\n"); }
                    ;

constant_expr: conditional_expr
                         { printf("constant-expr => conditional-expr\n"); }
                   ;

declaration: declaration_specifiers init_declarator_list_opt SEMICOLON
                 { printf("declaration => declaration-specifiers init-declarator-list-opt ;\n"); }
           ;

init_declarator_list_opt: init_declarator_list
                              { printf("init-declarator-list-opt => init-declarator-list\n"); }
                         |
                              { printf("init-declarator-list-opt => epsilon\n"); }
                         ;

init_declarator: declarator
                     { printf("init-declarator => declarator\n"); }
               | declarator ASSIGN initializer
                     { printf("init-declarator => declarator = initializer\n"); }
               ;

specifier_qualifier_list_opt: specifier_qualifier_list
                                  { printf("specifier-qualifier-list-opt => specifier-qualifier-list\n"); }
                            |
                                  { printf("specifier-qualifier-list-opt => epsilon\n"); }
                            ;

enum_specifier: ENUM identifier_opt LEFT_CURLY_BRACE enumerator_list RIGHT_CURLY_BRACE
                    { printf("enum-specifier => enum identifier-opt { enumerator-list }\n"); }
              | ENUM identifier_opt LEFT_CURLY_BRACE enumerator_list COMMA RIGHT_CURLY_BRACE
                    { printf("enum-specifier => enum identifier-opt { enumerator-list , }\n"); }
              | ENUM IDENTIFIER
                    { printf("enum-specifier => enum identifier\n"); }
              ;

identifier_opt: IDENTIFIER
                    { printf("identifier-opt => identifier\n"); }
              |
                    { printf("identifier-opt => epsilon\n"); }
              ;

storage_class_specifier: EXTERN
                             { printf("storage-class-specifier => extern\n"); }
                       | STATIC
                             { printf("storage-class-specifier => static\n"); }
                       | AUTO
                             { printf("storage-class-specifier => auto\n"); }
                       | REGISTER
                             { printf("storage-class-specifier => register\n"); }
                       ;

type_specifier: VOID
                    { printf("type-specifier => void\n"); }
              | CHAR
                    { printf("type-specifier => char\n"); }
              | SHORT
                    { printf("type-specifier => short\n"); }
              | INT
                    { printf("type-specifier => int\n"); }
              | LONG
                    { printf("type-specifier => long\n"); }
              | FLOAT
                    { printf("type-specifier => float\n"); }
              | DOUBLE
                    { printf("type-specifier => double\n"); }
              | SIGNED
                    { printf("type-specifier => signed\n"); }
              | UNSIGNED
                    { printf("type-specifier => unsigned\n"); }
              | BOOL
                    { printf("type-specifier => _Bool\n"); }
              | COMPLEX
                    { printf("type-specifier => _Complex\n"); }
              | IMAGINARY
                    { printf("type-specifier => _Imaginary\n"); }
              | enum_specifier
                    { printf("type-specifier => enum-specifier\n"); }
              ;

specifier_qualifier_list: type_specifier specifier_qualifier_list_opt
                              { printf("specifier-qualifier-list => type-specifier specifier-qualifier-list-opt\n"); }
                        | type_qualifier specifier_qualifier_list_opt
                              { printf("specifier-qualifier-list => type-qualifier specifier-qualifier-list-opt\n"); }
                        ;

enumerator_list: enumerator
                     { printf("enumerator-list => enumerator\n"); }
               | enumerator_list COMMA enumerator
                     { printf("enumerator-list => enumerator-list , enumerator\n"); }
               ;

enumerator: IDENTIFIER
                { printf("enumerator => enumeration-constant\n"); }
          | IDENTIFIER ASSIGN constant_expr
                { printf("enumerator => enumeration-constant = constant-expr\n"); }
          ;

type_qualifier_list_opt: type_qualifier_list
                             { printf("type-qualifier-list-opt => type-qualifier-list\n"); }
                       |
                             { printf("type-qualifier-list-opt => epsilon\n"); }
                       ;

assignment_expr_opt: assignment_expr
                               { printf("assignment-expr-opt => assignment-expr\n"); }
                         |
                               { printf("assignment-expr-opt => epsilon\n"); }
                         ;

identifier_list_opt: identifier_list
                         { printf("identifier-list-opt => identifier-list\n"); }
                   |
                         { printf("identifier-list-opt => epsilon\n"); }
                   ;

type_qualifier: CONST
                    { printf("type-qualifier => const\n"); }
              | RESTRICT
                    { printf("type-qualifier => restrict\n"); }
              | VOLATILE
                    { printf("type-qualifier => volatile\n"); }
              ;

function_specifier: INLINE
                        { printf("function-specifier => inline\n"); }
                  ;

declarator: pointer_opt direct_declarator
                { printf("declarator => pointer-opt direct-declarator\n"); }
          ;

pointer_opt: pointer
                 { printf("pointer-opt => pointer\n"); }
           |
                 { printf("pointer-opt => epsilon\n"); }
           ;

type_name: specifier_qualifier_list
               { printf("type-name => specifier-qualifier-list\n"); }
         ;

initializer: assignment_expr
                 { printf("initializer => assignment-expr\n"); }
           | LEFT_CURLY_BRACE initializer_list RIGHT_CURLY_BRACE
                 { printf("initializer => { initializer-list }\n"); }
           | LEFT_CURLY_BRACE initializer_list COMMA RIGHT_CURLY_BRACE
                 { printf("initializer => { initializer-list , }\n"); }
           ;

direct_declarator: IDENTIFIER
                       { printf("direct-declarator => identifier\n"); }
                 | LEFT_PARENTHESIS declarator RIGHT_PARENTHESIS
                       { printf("direct-declarator => ( declarator )\n"); }
                 | direct_declarator LEFT_SQUARE_BRACE type_qualifier_list_opt assignment_expr_opt RIGHT_SQUARE_BRACE
                       { printf("direct-declarator => direct_declarator [ type-qualifier-list-opt assignment-expr-opt ]\n"); }
                 | direct_declarator LEFT_SQUARE_BRACE STATIC type_qualifier_list_opt assignment_expr RIGHT_SQUARE_BRACE
                       { printf("direct-declarator => direct_declarator [ static type-qualifier-list-opt assignment-expr ]\n"); }
                 | direct_declarator LEFT_SQUARE_BRACE type_qualifier_list STATIC assignment_expr RIGHT_SQUARE_BRACE
                       { printf("direct-declarator => direct_declarator [ type-qualifier-list static assignment-expr ]\n"); }
                 | direct_declarator LEFT_SQUARE_BRACE type_qualifier_list_opt MULTIPLY RIGHT_SQUARE_BRACE
                       { printf("direct-declarator => direct_declarator [ type-qualifier-list-opt * ]\n"); }
                 | direct_declarator LEFT_PARENTHESIS parameter_type_list RIGHT_PARENTHESIS
                       { printf("direct-declarator => direct_declarator ( parameter-type-list )\n"); }
                 | direct_declarator LEFT_PARENTHESIS identifier_list_opt RIGHT_PARENTHESIS
                       { printf("direct-declarator => direct_declarator ( identifier-list-opt )\n"); }
                 ;

pointer: MULTIPLY type_qualifier_list_opt
             { printf("pointer => * type-qualifier-list-opt\n"); }
       | MULTIPLY type_qualifier_list_opt pointer
             { printf("pointer => * type-qualifier-list-opt pointer\n"); }
       ;

identifier_list: IDENTIFIER
                     { printf("identifier-list => identifier\n"); }
               | identifier_list COMMA IDENTIFIER
                     { printf("identifier-list => identifier_list , identifier\n"); }
               ;

type_qualifier_list: type_qualifier
                         { printf("type-qualifier-list => type-qualifier\n"); }
                   | type_qualifier_list type_qualifier
                         { printf("type-qualifier-list => type-qualifier-list type-qualifier\n"); }
                   ;

parameter_type_list: parameter_list
                         { printf("parameter-type-list => parameter-list\n"); }
                   | parameter_list COMMA ELLIPSIS
                         { printf("parameter-type-list => parameter-list , ...\n"); }
                   ;

parameter_list: parameter_declaration
                    { printf("parameter-list => parameter-declaration\n"); }
              | parameter_list COMMA parameter_declaration
                    { printf("parameter-list => parameter-list , parameter-declaration\n"); }
              ;

parameter_declaration: declaration_specifiers declarator
                           { printf("parameter-declaration => declaration-specifiers declarator\n"); }
                     | declaration_specifiers
                           { printf("parameter-declaration => declaration-specifiers\n"); }
                     ;

initializer_list: designation_opt initializer
                      { printf("initializer-list => designation-opt initializer\n"); }
                | initializer_list COMMA designation_opt initializer
                      { printf("initializer-list => initializer-list , designation-opt initializer\n"); }
                ;

designation_opt: designation
                     { printf("designation-opt => designation\n"); }
               |
                     { printf("designation-opt => epsilon\n"); }
               ;

designation: designator_list ASSIGN
                 { printf("designation => designator-list =\n"); }
           ;

designator_list: designator
                     { printf("designator-list => designator\n"); }
               | designator_list designator
                     { printf("designator-list => designator-list designator\n"); }
               ;

designator: LEFT_SQUARE_BRACE constant_expr RIGHT_SQUARE_BRACE
                { printf("designator => [ constant-expr ]\n"); }
          | DOT IDENTIFIER
                { printf("designator => . identifier\n"); }
          ;

statement: labeled_statement
               { printf("statement => labeled-statement\n"); }
         | compound_statement
               { printf("statement => compound-statement\n"); }
         | expr_statement
               { printf("statement => expr-statement\n"); }
         | selection_statement
               { printf("statement => selection-statement\n"); }
         | iteration_statement
               { printf("statement => iteration-statement\n"); }
         | jump_statement
               { printf("statement => jump-statement\n"); }
         ;

labeled_statement: IDENTIFIER COLON statement
                       { printf("labeled-statement => identifier : statement\n"); }
                 | CASE constant_expr COLON statement
                       { printf("labeled-statement => case constant-expr : statement\n"); }
                 | DEFAULT COLON statement
                       { printf("labeled-statement => default : statement\n"); }
                 ;

compound_statement: LEFT_CURLY_BRACE block_item_list_opt RIGHT_CURLY_BRACE
                        { printf("compound-statement => { block-item-list-opt }\n"); }
                  ;

block_item_list_opt: block_item_list
                         { printf("block-item-list-opt => block-item-list\n"); }
                   |
                         { printf("block-item-list-opt => epsilon\n"); }
                   ;

block_item_list: block_item
                     { printf("block-item-list => block-item\n"); }
               | block_item_list block_item
                     { printf("block-item-list => block-item-list block-item\n"); }
               ;

block_item: declaration
                { printf("block-item => declaration\n"); }
          | statement
                { printf("block-item => statement\n"); }
          ;

expr_statement: expr_opt SEMICOLON
                          { printf("expr-statement => expr-opt ;\n"); }
                    ;

expr_opt: expr
                    { printf("expr-opt => expr\n"); }
              |
                    { printf("expr-opt => epsilon\n"); }
              ;

selection_statement: IF LEFT_PARENTHESIS expr RIGHT_PARENTHESIS statement
                         { printf("selection-statement => if ( expr ) statement\n"); }
                   | IF LEFT_PARENTHESIS expr RIGHT_PARENTHESIS statement ELSE statement
                         { printf("selection-statement => if ( expr ) statement else statement\n"); }
                   | SWITCH LEFT_PARENTHESIS expr RIGHT_PARENTHESIS statement
                         { printf("selection-statement => switch ( expr ) statement\n"); }
                   ;

function_definition: declaration_specifiers declarator declaration_list_opt compound_statement
                         { printf("function-definition => declaration-specifiers declarator declaration-list-opt compound-statement\n"); }
                   ;

declaration_list_opt: declaration_list
                          { printf("declaration-list-opt => declaration-list\n"); }
                    |
                          { printf("declaration-list-opt => epsilon\n"); }
                    ;

declaration_list: declaration
                      { printf("declaration-list => declaration\n"); }
                | declaration_list declaration
                      { printf("declaration-list => declaration-list declaration\n"); }
                ;

iteration_statement: WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS statement
                         { printf("iteration-statement => while ( expr ) statement\n"); }
                   | DO statement WHILE LEFT_PARENTHESIS expr RIGHT_PARENTHESIS SEMICOLON
                         { printf("iteration-statement => do statement while ( expr ) ;\n"); }
                   | FOR LEFT_PARENTHESIS expr_opt SEMICOLON expr_opt SEMICOLON expr_opt RIGHT_PARENTHESIS statement
                         { printf("iteration-statement => for ( expr-opt ; expr-opt ; expr-opt ) statement\n"); }
                   | FOR LEFT_PARENTHESIS  declaration expr_opt SEMICOLON expr_opt RIGHT_PARENTHESIS statement
                         { printf("iteration-statement => for ( declaration expr-opt ; expr-opt ) statement\n"); }
                   ;

jump_statement: GOTO IDENTIFIER SEMICOLON
                    { printf("jump-statement => goto identifier ;\n"); }
              | CONTINUE SEMICOLON
                    { printf("jump-statement => continue ;\n"); }
              | BREAK SEMICOLON
                    { printf("jump-statement => break ;\n"); }
              | RETURN expr_opt SEMICOLON
                    { printf("jump-statement => return expr-opt ;\n"); }
              ;

translation_unit: external_declaration
                      { printf("translation-unit => external-declaration\n"); }
                | translation_unit external_declaration
                      { printf("translation-unit => translation-unit external-declaration\n"); }
                ;

external_declaration: function_definition
                          { printf("external-declaration => function-definition\n"); }
                    | declaration
                          { printf("external-declaration => declaration\n"); }
                    ;

%%

void yyerror(char *s) {
    printf("Line %d: %s^\n", yylineno, yytext);
    printf("Error type: %s\n", s);  
}