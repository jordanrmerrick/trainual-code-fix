open! Stdio

module Input = struct
  let read_file filename = 
    In_channel.read_lines filename

  let two_list_to_tuple = function 
    | x::y::_ -> x,y
    | _ -> failwith "wrong list length"

  let read_filenames () = 
    In_channel.input_lines stdin 
    |> two_list_to_tuple

end

(* Utility functions *)
let char_to_string c = 
  let buf = Buffer.create 1 in
  Buffer.add_char buf c; Buffer.contents buf

let string_to_string_array_aux s n = 
  let arr = Array.make n "" in
  for i=0 to n-1 do
    arr.(i) <- char_to_string s.[i]
  done;
  arr

let string_to_string_array s = 
  string_to_string_array_aux s (String.length s)

let array_to_string arr = 
  let buf = Buffer.create (Array.length arr) in
  Array.iter (Buffer.add_string buf) arr;
  Buffer.contents buf

(* The actual parse-and-replace functions *)
let replace_tilde = function
| 0 -> "<code \"font-style:14px;\">"
| 1 -> "</code>"
| _ -> failwith "Invalid num"

let scan_line arr n = 
  let rec aux stack i = 
    if i = n then arr else
      begin match arr.(i) = "`" with
        | true -> arr.(i) <- replace_tilde stack; aux (if stack = 1 then 0 else 1) (i+1)
        | false -> aux stack (i+1)
      end
  in
  aux 0 0

let scan_line_no_match arr n =
  let rec aux stack i = 
    if i = n then arr else 
      if arr.(i) = "`" then 
        begin arr.(i) <- replace_tilde stack;
        aux (if stack = 1 then 0 else 1) (i+1) 
        end 
      else aux stack (i+1)
  in
  aux 0 0

let scan_lines (ls : string array list) ~f = 
  let rec aux acc = function
  | [] -> acc
  | x::xs ->
      aux
        ((f x (Array.length x))::acc)
        xs
  in
  aux [] ls |> List.rev

let write filename (ls : string array list) = 
  List.map (array_to_string) ls |> fun x ->
  Out_channel.write_lines filename x


let () = 
  let r, w = Input.read_filenames () in
  let lines = Input.read_file r in
  List.map (string_to_string_array) lines
  |> scan_lines ~f:scan_line
  |> write w