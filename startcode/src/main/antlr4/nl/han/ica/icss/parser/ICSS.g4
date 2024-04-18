grammar ICSS;

//--- LEXER: ---

// IF support:
IF: 'if';
ELSE: 'else';
BOX_BRACKET_OPEN: '[';
BOX_BRACKET_CLOSE: ']';

//Literals
TRUE: 'TRUE';
FALSE: 'FALSE';
PIXELSIZE: [0-9]+ 'px';
PERCENTAGE: [0-9]+ '%';
SCALAR: [0-9]+;

//Color value takes precedence over id idents
COLOR: '#' [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f] [0-9a-f];

//Specific identifiers for id's and css classes
ID_IDENT: '#' [a-z0-9\-]+;
CLASS_IDENT: '.' [a-z0-9\-]+;

//General identifiers
LOWER_IDENT: [a-z] [a-z0-9\-]*;
CAPITAL_IDENT: [A-Z] [A-Za-z0-9_]*;

//All whitespace is skipped
WS: [ \t\r\n]+ -> skip;

//
OPEN_BRACE: '{';
CLOSE_BRACE: '}';
SEMICOLON: ';';
COLON: ':';
PLUS: '+';
MIN: '-';
MUL: '*';
ASSIGNMENT_OPERATOR: ':=';

//--- PARSER: ---
// General structure
stylesheet: variableAssignment* styleRule* EOF;
variableAssignment: variableReference ASSIGNMENT_OPERATOR expression SEMICOLON;
styleRule: selector OPEN_BRACE body CLOSE_BRACE;
body: (variableAssignment | declaration | ifClause)*;

// Declarations, expressions and operations
declaration: propertyName COLON expression SEMICOLON;
expression: literal | operation+;
operation: (literal | variableReference) (PLUS | MIN | MUL) (literal | variableReference);

// References and identifiers
variableReference: CAPITAL_IDENT;
propertyName: LOWER_IDENT;

classSelector: CLASS_IDENT;
idSelector: ID_IDENT;
selector: classSelector | idSelector;

// Literals
booleanLiteral: TRUE | FALSE;
pixelLiteral: PIXELSIZE;
percentageLiteral: PERCENTAGE;
colorLiteral: COLOR;
scalarLiteral: SCALAR;
literal: booleanLiteral | pixelLiteral | percentageLiteral | colorLiteral | scalarLiteral;

// Conditional operations
ifClause: IF BOX_BRACKET_OPEN (booleanLiteral | expression | variableReference) BOX_BRACKET_CLOSE OPEN_BRACE body CLOSE_BRACE elseClause?;
elseClause: ELSE OPEN_BRACE (declaration+ | ifClause) CLOSE_BRACE;