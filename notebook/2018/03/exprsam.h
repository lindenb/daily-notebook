#ifndef EXPR_SAM_H
#define EXPR_SAM_H

typedef char CHAR;	/* Character type */
typedef char *STRING;	/* String type */
typedef float FLOAT;
typedef long INT;	


typedef	struct	TERM {
	CHAR	t_op;			/* Op type */
	CHAR	t_flag;
	struct	TERM	*t_next;	/* Hash chain */
	unsigned t_hval;		/* Hash value for symbol table */
	unsigned t_ahval;		/* Hash value without array index */
	union {
		FLOAT	t_float;
		INT	t_int;
		STRING	t_str;
		struct {
			union	NODE	*(*t_func)();
			CHAR	t_minarg;
			CHAR	t_maxarg;
		}	t_fun;
	}	t_un;
	CHAR	t_name[];		/* Name of array or identifier */
}	TERM;




typedef	union	NODE {

	TERM	term;
}	NODE;

NODE* node(int,NODE*,NODE*);

#endif

