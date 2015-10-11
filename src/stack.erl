%% "Stacking image data"
%
% Start with:
% > erl -noshell -s stack main [<filenames>] -s init stop
% > erl -noshell -s stack main a.pnm b.pnm c.pnm -s init stop

-module(stack).
-export([main/1, new/0, add/2, toImage/1, readImage/1]).
-export([randomImage/1]).

%---

main(Args) ->
  Stack = addFile(new(), Args),
  Image = toImage(Stack),
  io:fwrite("=> ~p~n", [Image]),
  writeImage("result.pnm", Image).

%---

addFile(Stack, []) ->
  Stack;
addFile(Stack, [Filename | T]) ->
  NewStack = add(Stack, readImage(Filename)),
  io:fwrite("-> ~p~n", [NewStack]),
  addFile(NewStack, T).

%---

new() ->
  {stack, 0, nil}.

%---

add({stack, 0, nil}, {image, L}) ->
  {stack, 1, L};

add({stack, N, Stack}, {image, L}) ->
  {stack, N + 1, addTo(Stack, L)}.


toImage({stack, N, Stack}) ->
  {image, divide(Stack, N)}.

%---

readImage(Filename) ->
  {ok, B} = file:read_file(Filename),
  L = binary:bin_to_list(B),
  {image, L}.

%---

writeImage(Filename, {image, L}) ->
  B = binary:list_to_bin(L),
  io:fwrite("=> ~p~n", [B]),
  file:write(Filename, B).

%---

addTo([], []) ->
  [];

addTo([H | T], [HD | TD]) ->
  [H + HD | addTo(T, TD)].

%---

divide([], _) ->
  [];
divide([H | T], N) ->
  [trunc(H / N) | divide(T, N)].

%---

randomImage(L) ->
  {image, randomList(L)}.


randomList(0) ->
  [];
randomList(L) ->
  [randomItem() | randomList(L - 1)].


randomItem() ->
  random:uniform(256).
