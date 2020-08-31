(* open Typed *)
(* open Util *)

module P4Int = Types.P4Int

type datatype =
  | TInteger
  | TBitstring of int
  | TError
  | TMatchKind
  | TRecord of { fields : (string * datatype) list; }
  | THeader of { fields : (string * datatype) list; }
  | TTypeName of string

and parsertype = unit (* TODO *)

and controltype = unit (* TODO *)

and tabletype = unit (* TODO *)

and coretype =
  | TDataType of datatype
  | TParser of parsertype
  | TControl of controltype
  | TTable of tabletype
  | TFunction of {
    typ_params : string list;
    params : (dir * string * datatype) list;
    ret : datatype;
  }
  | TConstructor of {
    params : (string * datatype) list;
    ret : coretype;
  }

and dir =
  | In
  | Out
  | InOut

and uop = unit (* TODO *)

and bop = unit (* TODO *)

and expr =
  | Integer of {
    v : int
  }
  | Bitstring of {
    w : int;
    v : Bigint.t;
  }
  | Var of {
    name : string
  }
  | Uop of {
    op : uop;
    expr : expr
  }
  | Bop of {
    op : bop;
    lhs : expr;
    rhs : expr;
  }
  | Cast of {
    typ : datatype;
    expr : expr;
  }
  | Record of {
    fields : (string * expr) list;
  }
  | ExprMember of {
    expr : expr;
    mem : string;
  }
  | Error of {
    name : string
  }
  | Call of {
    callee : expr;
    args : expr list;
  }

and ctrl_stmt =
  | CAssign of {
    lhs : expr;
    rhs : expr;
  }
  | Conditional of {
    guard : expr;
    t : ctrl_stmt;
    f : ctrl_stmt;
  }
  | Block of {
    blk : ctrl_stmt list;
  }
  | Exit
  | Return of {
    v : expr option;
  }
  | CVarDecl of {
    decl : decl
  }

and prsr_stmt =
  | PAssign of {
    lhs : expr;
    rhs : expr;
  }
  | PVarDecl of {
    decl : decl
  }
  | Select of {
    cases : select;
  }

and select = unit (* TODO *)

and decl =
  | Variable of {
    typ : datatype;
    var : string;
    expr : expr option;
  }
  | Instantiation of {
    typ_name : string;
    args : expr list;
    var : string;
    (* TODO: possible an initialization block *)
  }
  | ErrorDecl of {
    errs : string list;
  }
  | MatchKind of {
    mks : string list;
  }
  | Type of {
    typ : coretype;
    name : string;
  }
  | Extern of unit (* TODO *)
  | Function of unit (* TODO *)

and obj_decl =
  | Control of control_decl
  | Parser of parser_decl

and control_decl = {
  ctrl_args : arg list;
  actions : action_decl list;
  tbls : table_decl list;
  apply : ctrl_stmt list;
}

and parser_decl = {
  prsr_args : arg list;
  states : state list;
} (* TODO *)

and arg = unit (* TODO *)

and state = prsr_stmt list

and action_decl = unit (* TODO *)

and table_decl = unit (* TODO *)

and pkg_invocation

and program = {
  decls : decl list;
  objs : obj_decl list; (* don't be so strict about separation *)
  main : (ctrl_stmt list * pkg_invocation);
}


(** How to get there? 

1)  Global substitution of constants and typdefs (optional). Result
    should be a valid P4 program passing our type-checker.

2)  Inline function bodies and copy-in/copy-out, including method calls,
    function calls nested in expressions, explicit action calls. Should also
    inline the copy-in/copy-out semantics for direct applications, extern
    function/method/constructor calls, and built-in function calls.
    Result should be a valid P4 program passing our type-checker.

3)  Inline nested parser/control declarations by lifting parser states from
    sub-parses, inlining apply blocks of sub-controls, and lifting local
    declarations from sub-parsers and sub-controls. Result should be a valid
    P4 program passing our type-checker.

4)  Collapse error and matchkind declarations and lift them to the top of the
    program. Result should be a valid P4 program passing our type-checker.

5)  For the remaining parsers and controls, lift the local declarations to
    global space. Result should be expressable in our P4 AST, but may not
    pass the type-checker due to restrictions on various kinds of declarations.
    We may be able to run a subset of the type-checker.

6)  Translation from P4 into the P4 core language described above. Most of the
    transformations are related to expressing some of P4's more complex data
    types in terms of headers and structs.

Notes : 

- Keep externs in the syntax in some simplified form.

- Keep architectures/packages abstract; translation is not target-dependent



*)