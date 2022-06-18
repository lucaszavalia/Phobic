#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "structures.h"

int ast_id_counter = 1;

struct AST * new_node(int tok, char * str) {
   struct AST * new_n = (struct AST *) malloc(sizeof(struct AST) + (strlen(str)*sizeof(char)));
   if (new_n) {
      new_n->id         = ast_id_counter;
      ast_id_counter    = ast_id_counter + 1;
      new_n->token      = tok;
      new_n->string     = str;
      new_n->next       = NULL;
      new_n->child      = NULL;
   }
   return new_n;
}

struct AST * add_sibling(struct AST * tree, int tok, char * str) {
   if (tree == NULL) {return NULL;}
   while (tree->next != NULL) {tree = tree->next;}
   return (tree->next = new_node(tok, str));
}

struct AST * add_child(struct AST * tree, int tok, char * str) {
   if (tree == NULL) {return NULL;}
   if (tree->child != NULL) {return add_sibling(tree->child, tok, str);}
   else {return (tree->child = new_node(tok, str));}
}

int find_id(struct AST * tree, int src_id) {
   if (tree == NULL) {return 0;}
   if (tree->id == src_id) {return 1;}
   return (find_id(tree->next, src_id) + find_id(tree->child, src_id));
}

int insert_node(struct AST * tree, int src_id, int trgt_id, char * str) {
   if (tree == NULL) {return 0;}
   if (tree->id == src_id) {
      add_child(tree, trgt_id, str);
      return tree->id;
   }
   return (insert_node(tree->next, src_id, trgt_id, str) + insert_node(tree->child, src_id, trgt_id, str)); 
}

struct AST * add_sibling_ast(struct AST * tree, struct AST * subtree) {
   if (tree == NULL) {return NULL;}
   while (tree->next != NULL) {tree = tree->next;}
   return (tree->next = subtree);
}

struct AST * concat_ast(struct AST * tree, struct AST * subtree) {
   if (tree == NULL) {return NULL;}
   if (tree->child != NULL) {return add_sibling_ast(tree->child, subtree);}
   else {return (tree->child = subtree);}
}

struct AST * concat_ast_id(int key, struct AST * tree, struct AST * subtree) {
   if (tree == NULL) {return NULL;}
   if (tree->id == key) {
      printf("PING\n");
      if (tree->child == NULL) {tree->child = subtree;}
      else {
         while (tree->next != NULL) {tree = tree->next;}
	 return (tree->next = subtree);
      }
   }
   concat_ast_id(key, tree->next, subtree);
   concat_ast_id(key, tree->child, subtree);
}

/*void copy_tree(struct AST * tree, struct AST * new_tree) {
   if (tree == NULL) {return;} 
   copy_tree(tree->child, new_tree);
   copy_tree(tree->next, new_tree);
}*/
 
void _print_AST(struct AST * tree, int level) {
   if (tree == NULL) {return;}
   printf("\nid: %d\ntoken: %d\nstring: %s\nlevel: %d\n", tree->id, tree->token, tree->string, level);
   _print_AST(tree->next, level);
   _print_AST(tree->child, level+1);
   return;
}

void print_AST(struct AST * tree) {
   _print_AST(tree, 0);
   return;
}

void get_AST_label_dot(struct AST * tree, FILE * fp) {
   if (tree == NULL) {return;}
   fprintf(fp, "id%d [label=\"%s , %d\", fontname=\"monospace\"];\n", tree->id, tree->string, tree->id);
   get_AST_label_dot(tree->next, fp);
   get_AST_label_dot(tree->child, fp);
}

void get_AST_edges_dot(struct AST * tree, FILE * fp) {
   if (tree == NULL) {return;}
   struct AST * temp = tree->child;
   while (temp != NULL) {
      fprintf(fp, "id%d->id%d;\n", tree->id, temp->id);
      temp = temp->next;
   }
   get_AST_edges_dot(tree->next, fp);
   get_AST_edges_dot(tree->child, fp);
}

void print_AST_dot(struct AST * tree, char * filename) {
   FILE * fp = fopen(filename, "w");
   int i;
   if (fp == NULL) return;
   fprintf(fp, "digraph {\n");
   get_AST_label_dot(tree, fp);
   get_AST_edges_dot(tree, fp);
   fprintf(fp, "}\n");
   fclose(fp);
   return;
}

void delete_subtree(int key, struct AST * tree) {
   if (tree == NULL) {return;}
   if (tree->id == key) {
      free(tree->child);
      tree->child = NULL;
   }
   delete_subtree(key, tree->next);
   delete_subtree(key, tree->child);
}

void free_AST(struct AST * tree) {
   if (tree == NULL) {return;}
   free_AST(tree->next);
   free_AST(tree->child);
   free(tree);
   return;
}

/*int main() {
   printf("testing tree structure\n");
   char * test = (char *) malloc(5*sizeof(char));
   sprintf(test, "test");
   struct AST * ast = new_node(-1, test);
   add_child(ast, -2, test);
   add_child(ast, -3, test);
   add_child(ast, -4, test);
   add_child(ast->child->next, -5, test);
   add_child(ast->child->next, -6, test);
   struct AST * subtree = new_node(100, "NIGGER");
   add_child(subtree, 200, "NIGGER");
   add_child(subtree, 300, "NIGGER");
   struct AST * faggots = new_node(400, "FAGGOT");
   add_child(faggots, 500, "FILTHY");
   add_child(faggots, 600, "DERANGED");
   int res = find_id(ast, 2);
   if (res == 1) {printf("id 2 found\n");}
   else {printf("id 2 not found\n");}
   res = insert_node(ast, 3, -7, test);
   if (res == 0) {printf("id not found\n");}
   else {printf("returned %d\n", res);}
   printf("testing ast concat\n");
   concat_ast_id(2, ast, subtree);
   concat_ast(ast, faggots);
   printf("test completed\n");
   printf("remaining AST:\n");
   print_AST(ast);
   print_AST_dot(ast, "ast.dot");
   free_AST(ast);
   free(test);
   test = NULL;
   ast = NULL;
   subtree = NULL;
   return 0;
}*/
