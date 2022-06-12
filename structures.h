struct AST {
   int id;
   int token;
   char * string;
   struct AST * next;
   struct AST * child;
};

struct AST * new_node(int, char *);
struct AST * add_sibling(struct AST *, int, char *);
struct AST * add_child(struct AST *, int, char *);
struct AST * add_sibling_ast(struct AST *, struct AST *);
struct AST * concat_ast(struct AST *, struct AST *);
struct AST * concat_ast_id(int, struct AST *, struct AST *);
struct AST * split_ast(int, struct AST *);
int find_id(struct AST *, int);
int insert_node(struct AST *, int, int, char *);
void copy_ast(struct AST *, struct AST *);
void _print_AST(struct AST *, int);
void print_AST(struct AST *);
void get_AST_label_dot(struct AST *, FILE *);
void get_AST_edges_dot(struct AST *, FILE *);
void print_AST_dot(struct AST *, char *);
void delete_subtree(int, struct AST *);
void free_AST(struct AST *);
