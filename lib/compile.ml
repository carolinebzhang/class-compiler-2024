let compile (program : string) : string =
  String.concat "\n"
    ["global entry"; "entry:"; Printf.sprintf "\tmov rax, %s" program; "\tret"]

let compile_to_file (program : string) : unit =
  let file = open_out "program.s" in
  output_string file (compile program) ;
  close_out file

let compile_and_run (program : string) : string =
  compile_to_file program ; (** it says string to unit, unit type only has one element () *)

  (); (**we care about compile_to_file's side effects, it opens a file, compiles the file, closes the file, 
  unit just means we care about what file does, not what it retruns necessarily  semicolon 
  just means ignore this and go to the next line ?*)

  (** if things are mutable we have to let ocaml know *) 
  (** type of ignore is -a to unit so we ca ignmore any kind of value*)
  (** for instance list.reverse would be a polymorphic function *)
  (**ignore is a polymorphic function - behavior doesn't depend on the value it's taking in / type of value*)
  ignore (Unix.system "nasm program.s -f elf64 -o program.o") ; 
  ignore (Unix.system "gcc program.o runtime.o -o program -z noexecstack") ;
  let inp = Unix.open_process_in "./program" in
  let r = input_line inp in (** r is the last thing in the sequence so it's the thing that gets returned *) 

  close_in inp ; r


