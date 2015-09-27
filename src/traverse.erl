%%%-------------------------------------------------------------------
%%% @author Ralf Th. Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2015, Ralf Th. Pietschs
%%% @doc
%%% Some experiments for traverse file system ...
%%% @end
%%% Created : 27. Sep 2015 21:50
%%%-------------------------------------------------------------------
-module(traverse).
-author("ratopi@abwesend.de").

%% API
-export([traverse/1, traverseX/1, traverseY/1]).

traverse(Dir) ->
  {ok, Files} = file:list_dir(Dir),
  print(Files).

traverseX(Dir) ->
  {ok, Files} = file:list_dir_all(Dir),
  print(Files).

traverseY(Dir) ->
  Fun = fun(F, _) ->
    LastModified = filelib:last_modified(F),
    Size = filelib:file_size(F),
    io:fwrite("~p ~p ~p~n", [Size, F, LastModified])
  end,
  Acc = 0,
  filelib:fold_files(Dir, ".*", true, Fun, Acc).

print([F | R]) ->
  io:fwrite("~p~n", [F]),
  print(R);
print([]) ->
  ok.
