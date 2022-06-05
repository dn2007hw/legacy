(* c-types.sml
 *
 * COPYRIGHT (c) 1999 Bell Labs, Lucent Technologies
 *
 * A representation of C Types for specifying the arguments and results
 * of C function calls.
 *)


structure CTypes =
  struct

    datatype c_type
      = C_void
      | C_float
      | C_double
      | C_long_double
      | C_unsigned of c_int
      | C_signed of c_int
      | C_PTR
      | C_ARRAY of (c_type * int)
      | C_STRUCT of c_type list
      | C_UNION of c_type list

    and c_int
      = I_char
      | I_short
      | I_int
      | I_long
      | I_long_long

  (* multiple calling conventions on a single architecture *)
    type calling_convention = string

  (* prototype describing C function *)
    type c_proto = {
	conv : calling_convention,
	retTy : c_type,
	paramTys : c_type list
      }

    (* eliminate aggregates in a C type *)
    fun flattenCTy cTy = (case cTy
        of (C_STRUCT cTys |
	    C_UNION cTys ) => List.concat (List.map flattenCTy cTys)
	 | C_ARRAY (cTy, n) => List.tabulate (n, fn _ => cTy)
	 | cTy => [cTy])

  (* conversions to strings *)
    local

      fun ci I_char = "char"
	| ci I_short = "short"
	| ci I_int = "int"
	| ci I_long = "long"
	| ci I_long_long = "long long"

      fun ct C_void = "void"
	| ct C_float = "float"
	| ct C_double = "double"
	| ct C_long_double = "long double"
	| ct (C_unsigned i) = "unsigned " ^ ci i
	| ct (C_signed i) = ci i
	| ct C_PTR = "T*"
	| ct (C_ARRAY(t,i)) = concat [ct t, "[", Int.toString i, "]"]
	| ct (C_STRUCT fl) =
	  concat ("s{" :: foldr (fn (f, l) => ct f :: ";" :: l) ["}"] fl)
	| ct (C_UNION fl) =
	  concat ("u{" :: foldr (fn (f, l) => ct f :: ";" :: l) ["}"] fl)
    in
    val toString = ct

    fun protoToString { conv, retTy, paramTys = a1 :: an } =
	  concat (ct retTy :: "(*)(" :: ct a1 ::
		  foldr (fn (a, l) => "," :: ct a :: l) [")"] an)
      | protoToString { conv, retTy, paramTys = [] } = ct retTy ^ "(*)(void)"
    end (* local *)

  end
