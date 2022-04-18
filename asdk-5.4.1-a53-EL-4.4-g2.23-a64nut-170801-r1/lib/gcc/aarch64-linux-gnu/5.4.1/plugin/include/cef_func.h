/*
 *  cef_func.h
 *
 *  Created by Chung-Kai Chen on 2011/4/29.
 *  Copyright 2011 Realtek, Inc.. All rights reserved.
 */

#include "cef_file.h"

#include "tm.h"
#include "opts.h"
#include "hash-set.h"
#include "fixed-value.h"
#include "alias.h"
#include "symtab.h"
#include "inchash.h"
#include "tree.h"

#include "hard-reg-set.h"
#include "plugin-api.h"
#include "hash-map.h"
#include "is-a.h"
#include "function.h"
#include "ipa-ref.h"
#include "cgraph.h"

extern void collect_attrs (tree decl, bool is_definition, bool is_static);
extern void collect_attrs_lto (cgraph_node *node);
extern void collect_inline (tree caller, tree callee);
extern void collect_inline_rejected (cgraph_edge *e);
extern void collect_function_versioning (tree old_decl, tree new_decl);
extern void intervene_attrs (tree decl, tree *attributes);
extern bool ffp ();

struct fn_rename_entry {
  const char *fn_orig_name;
  const char *fn_new_name;
};
extern htab_t fn_rename_htab;

extern const char *get_orig_name (const char *name);
extern void set_rename (const char *orig_name, const char *new_name);
