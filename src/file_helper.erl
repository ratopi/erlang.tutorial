%%
%% Based on code from http://www.erlang.org/article/11
%%

-module(file_helper).
-export([with_file/3]).

with_file(File, Fun, Initial) ->
  case file:open(File, [read, raw, binary]) of
    {ok, Fd} ->
      Res = feed(Fd, file:read(Fd, 1024), Fun, Initial),
      file:close(Fd),
      Res;
    {error, Reason} ->
      {error, Reason}
  end.

feed(Fd, {ok, Bin}, Fun, Farg) ->
  case Fun(Bin, Farg) of
    {done, Res} ->
      Res;
    {more, Ack} ->
      feed(Fd, file:read(Fd, 1024), Fun, Ack)
  end;
%feed(Fd, eof, Fun, Ack) ->
feed(_, eof, _, Ack) ->
  Ack;
feed(_Fd, {error, Reason}, _Fun, _Ack) ->
  {error, Reason}.
