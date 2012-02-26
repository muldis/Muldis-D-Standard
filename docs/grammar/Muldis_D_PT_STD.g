grammar Muldis_D_PT_STD;

Muldis_D :
    WS?
        language_name WS
        (value | package)
    WS?
    ;

stmt :
      stmt_name
    | named_stmt
    | compound_stmt
    | multi_upd_stmt
    | try_catch_stmt
    | if_else_stmt
    | given_when_def_stmt
    | leave_or_iterate_or_loop_stmt
    | pcfix_proc_invo
    | prefix_proc_invo
    | infix_proc_invo
    ;

stmt_name :
    bldq_fmt_name
    ;

pcfix_proc_invo :
    name_chain WS? proc_arg_list
    ;

proc_arg_list :
    '(' WS?
        commalist_sep?
        (
              (proc_arg commalist_sep)+
            | proc_arg
            | ''
        )?
    WS? ')'
    ;

commalist_sep :
    WS? ',' WS?
    ;

prefix_proc_invo :
    bwbt_fmt_name WS? expr
    ;

infix_proc_invo :
    expr WS? bwbt_fmt_name WS? expr
    ;

expr :
      delim_expr
    | expr_name
    | named_expr
    | blob_lit      /* 0x'...' */
    | text_lit      /* '...' */
    | rational_lit  /* 5/6 */
    | float_lit     /* 3.13*2^24 */
    | integer_lit   /* 42 or 0x3F */
    | name_lit      /* $foo */
    | name_chain_lit    /* $$foo.bar */
    | scalar_sel    /* $:foo or $:foo:{x:y,...} or $:True */
    | tuple_sel     /* %:{x:y,...} or %:{} */
    | relation_sel  /* @:{...} or @:[...]:{...} or @:{} or @:{{}} */
    | set_sel       /* {x,...} or {} */
    | dict_sel      /* &:{x=>y,...} or &:{} */
    | array_sel     /* [x,...] or [] */
    | bag_sel       /* +:{x,x,...} or +:{x=>y,...} or +:{} */
    | interval_sel  /* x..y or x^..^y or $:∞..$:∞ */
    | list_sel      /* ^:[...] or ^:[] */
    | accessor
    | if_else_expr
    | given_when_def_expr
    | pcfix_func_invo
    | prefix_func_invo
    | infix_func_invo
    ;

delim_expr :
    '(' WS? expr WS? ')'
    ;

expr_name :
    bldq_fmt_name
    ;

integer_lit :
      bin_fmt_integer
    | oct_fmt_integer
    | hex_fmt_integer
    | dec_fmt_integer
    ;

dec_fmt_integer :
    '0d'? unq_fmt_integer
    ;

unq_fmt_integer :
      '0'
    | ('-'? '1'..'9' ('0'..'9')*)
    ;

unq_fmt_nn_integer :
      '0'
    | ('1'..'9' ('0'..'9')*)
    ;

name_lit :
    '$' bldq_fmt_name
    ;

name_chain_lit :
    '$$' name_chain
    ;

name_chain :
    name_chain_head name_chain_tail?
    ;

name_chain_head :
    ('.$' | unq_fmt_nn_integer '$')? bldq_fmt_name 
    ;

name_chain_tail :
    ('.' bldq_fmt_name)+
    ;

pcfix_func_invo :
    name_chain WS? func_arg_list
    ;

func_arg_list :
    '(' WS?
        commalist_sep?
        (
              (func_arg commalist_sep)+
            | func_arg
            | ''
        )?
    WS? ')'
    ;

prefix_func_invo :
    bwbt_fmt_name WS? expr
    ;

infix_func_invo :
    expr WS? bwbt_fmt_name WS? expr
    ;

bldq_fmt_name :
    bareletter_fmt_name | doublequote_fmt_name
    ;

bsbt_fmt_name :
    baresymbol_fmt_name | backtick_fmt_name
    ;

bareletter_fmt_name :
    (bareword_letter | '_') (bareword_letter | '_' | '0'..'9')*
    ;

bareword_letter :
      'a'..'z'|'A'..'Z'
    | 'Α'..'Ρ'|'Σ'..'Ω'|'α'..'ω'
    ;

baresymbol_fmt_name :
    bareword_symbol_char+
    ;

bareword_symbol_char :
      '!'|'#'|'$'|'%'|'&'|'*'|'+'|'-'|'/'|':'|'<'|'='|'>'|'?'|'@'|'^'|'|'
    | '¬'|'±'|'×'|'÷'|'←'|'↑'|'→'|'↓'|'↔'|'↚'|'↛'|'↮'|'∀'|'∃'|'∄'|'∅'
    | '∆'|'∈'|'∉'|'∋'|'∌'|'∖'|'∞'|'∧'|'∨'|'∩'|'∪'|'≠'|'≤'|'≥'|'⊂'|'⊃'
    | '⊄'|'⊅'|'⊆'|'⊇'|'⊈'|'⊉'|'⊤'|'⊥'|'⊻'|'⊼'|'⊽'|'⊿'|'⋊'|'⋈'|'⋉'|'▷'
    | '⟕'|'⟖'|'⟗'|'⨝'|'⨯'|'
    ;




FLOAT
    :   ('0'..'9')+ '.' ('0'..'9')* EXPONENT?
    |   '.' ('0'..'9')+ EXPONENT?
    |   ('0'..'9')+ EXPONENT
    ;

COMMENT
    :   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
    ;

WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

STRING
    :  '\'' ( ESC_SEQ | ~('\\'|'\'') )* '\''
    ;

CHAR:  '\'' ( ESC_SEQ | ~('\''|'\\') ) '\''
    ;

fragment
EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;
