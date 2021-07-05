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
| 0 -> "<code style=\"font-size:14px;\">"
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

let handler ls = 
  List.map string_to_string_array ls
  |> scan_lines ~f:scan_line
  |> List.map array_to_string