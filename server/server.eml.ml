open! Parse

let home request =
  <html>
  <body>
    <%s! Dream.form_tag ~action:"/" ~enctype:`Multipart_form_data request %>
      <input name="files" type="file" multiple>
      <button>Submit!</button>
    </form>
  </body>
  </html>


let linebreak s = String.split_on_char '\n' s

let report files = 
  <html>
  <body>
%   files |> List.iter begin fun (_, content) -> 
%     let content_p = linebreak content in
%      content_p |> Parse.handler |> List.iter begin fun ic ->
        <p><%s ic %></p>
%     end;
%   end;
  </body>
  </html>

let () = 
  Dream.run
  @@ Dream.logger
  @@ Dream.memory_sessions
  @@ Dream.router [
    Dream.get "/" (fun request ->
      Dream.html (home request));

    Dream.post "/" (fun request ->
      match%lwt Dream.multipart request with
      | `Ok ["files", files] -> Dream.html (report files)
      | _ -> Dream.empty `Bad_Request);
  ]
  @@ Dream.not_found