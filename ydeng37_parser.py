
import sys
import ply.lex as lex
sys.path.insert(0, "../..")
tokens = ('ID',   # ID represents a variable name
          'NUM',  # NUM represents the signed integer data type
          'EXP',  # EXP represents the exponentiation operator (**)
          'STR',  # STR represents the string data type
          'VAR'   # var represents the literal string 'VAR'
          )
literals = ['=', '+', '-', '*', '/']
def t_VAR(t):# create a method for parsing VAR tokens
  r'VAR'# regex for finding VAR tokens
  return t# return token
def t_ID(t):# create a method for parsing ID tokens
  r'([a-zA-Z]+)'# regex for finding ID tokens
  return t# return token
def t_NUM(t):# create a method for parsing NUM tokens
  r'-?\d+'# regex for finding NUM tokens
  t.value = int(t.value)# convert token from str to int
  return t# return token
          
def t_EXP(t):# create a method for parsing EXP tokens
  r'\*\*' # regex for finding EXP tokens
  return t# return token
def t_STR(t):# create a method for parsing STR tokens
  r'".*?"'# regex for finding STR tokens
  return t# return token
t_ignore = " \t"
def t_newline(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)
# Build the lexer
import ply.lex as lex
lexer = lex.lex()

# dictionary of names
names = {}
def p_expression_stmt(p):#define stmt
    '''stmt : assign
            | binop
            | declare'''
def p_expression_assign(p):#define assign
    '''assign : ID '=' term
              | ID '=' STR'''
    p[1] = p[3]#assign
def p_expression_binop(p):#define binop
    '''binop : term '+' term
             | term '-' term
             | term '*' term
             | term '/' term
             | term EXP term
             | STR '+' STR'''
  #implement the calculation which prevents string+int also
    if p[2] == '+':
        p[0] = p[1] + p[3]
    elif p[2] == '-':
        p[0] = p[1] - p[3]
    elif p[2] == '*':
        p[0] = p[1] * p[3]
    elif p[2] == '/':
        p[0] = p[1] / p[3]
    elif p[2] == '**':
        p[0] = p[1] ** p[3]
def p_expression_declare(p):#define declare
    '''declare : VAR ID
               | VAR assign'''
def p_expression_term(p):#define term
    '''term : ID
            | NUM
            | binop'''
    p[0]=p[1]#assign content to term, really important
def p_error(p):
    if p:
        print("Syntax error at '%s'" % p.value)
    else:
        print("Syntax error at EOF")
import ply.yacc as yacc
parser = yacc.yacc()
while True:
    try:
        s = input("Enter a line of code: ")
    except EOFError:
        break
    if not s:
        continue
    yacc.parse(s)
