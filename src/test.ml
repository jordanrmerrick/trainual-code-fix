open! Core_bench
open! Core
open! Main

let file = read_file "test.html" |> List.map ~f:(string_to_string_array) 

let () = 
  Command.run (Bench.make_command [
    Bench.Test.create ~name:"baseline"
      (fun () -> ());

    Bench.Test.create ~name:"pattern matching"
      (fun () -> ignore (scan_lines ~f:scan_line file));

    Bench.Test.create ~name:"no pattern matching"
      (fun () -> ignore (scan_lines ~f:scan_line_no_match file));
  ])

