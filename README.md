# Notes

This repository is forked from Petr4 (https://github.com/cornell-netlab/petr4) 
and is a submodule of ProD3 (https://github.com/MollyDream/ProD3).
All the changes are kept in `prod3/`. To properly set up the ocaml toplevel, 
you need to include the following lines in `~/.ocamlinit`.

```
#use "topfind"
#thread
#require "core.top"
#directory "+compiler-libs"

 let try_finally ~always f =
   match f () with
   | x ->
     always ();
     x
   | exception e ->
     always ();
     raise e

 let use_output command =
   let fn = Filename.temp_file "ocaml" "_toploop.ml" in
   try_finally
     ~always:(fun () -> try Sys.remove fn with Sys_error _ -> ())
     (fun () ->
       match
         Printf.ksprintf Sys.command "%s > %s" command (Filename.quote fn)
       with
       | 0 -> ignore (Toploop.use_file Format.std_formatter fn : bool)
       | n -> Format.printf "Command exited with code %d.@." n)

 let () =
   let name = "use_output" in
   if not (Hashtbl.mem Toploop.directive_table name) then
     Hashtbl.add Toploop.directive_table name
       (Toploop.Directive_string use_output)

;;
#remove_directory "+compiler-libs"
```

Then you can run the following commands in this repository:
```
ocaml

ocaml> #use "./prod3/import.ml";;
ocaml> #use "./prod3/new_main.ml";;
ocaml> #use "./prod3/command.ml";;
```
You can change `command.ml` (see the code) to generate the parsed, elaborated and typed ASTs.

# Welcome to Petr4

The Petr4 project is developing the formal semantics of the [P4
Language](https://p4.org) backed by an independent reference
implementation.

## Getting Started

### Installing Petr4

1. Install OPAM 2 following the official [OPAM installation
   instructions](https://opam.ocaml.org/doc/Install.html). Make sure `opam
   --version` reports version 2 or later.

1. Install external dependencies:
   ```
   sudo apt-get install m4 libgmp-dev
   ```

#### Installing from OPAM
1. Install petr4 from the opam repository. This will take a while the first time
   because it installs OPAM dependencies.
   ```
   opam install petr4
   ```

#### Installing from source
1. Check the installed version of OCaml:
    ```
    ocamlc -v
    ```
    If the version is less than 4.09.0, upgrade:
    ```
    opam switch 4.09.0
    ```

1. Install [p4pp](https://github.com/cornell-netlab/p4pp) from source.

1. Use OPAM to install dependencies. 
   ```
   opam install . --deps-only
   ```

1. Build binaries using the supplied `Makefile`
   ```
   make
   ```

1. Install binaries in local OPAM directory
   ```
   make install
   ``` 

1. [Optional] Run tests
   ``` 
   make test
   ```

### Running Petr4

Currently `petr4` is merely a P4 front-end. By default, it will parse
a source program to an abstract syntax tree and print it out, either
as P4 or encoded into JSON.

Run `petr4 -help` to see the list of currently-supported options.

### Web user interface

`petr4` uses `js_of_ocaml` to provide a web interface. To compile to javascript,
run `make web`. Then open `index.html` in `html_build` in a browser.

## Contributing

Petr4 is an open-source project. We encourage contributions!
Please file issues on
[Github](https://github.com/cornell-netlab/petr4/issues).

## Credits

See the list of [contributors](CONTRIBUTORS).

## License

Petr4 is released under the [Apache2 License](LICENSE).
