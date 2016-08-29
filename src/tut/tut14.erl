%
% Modified Example from http://www.erlang.org/doc/getting_started/conc_prog.html
%

-module(tut14).

-export([start/0, start/1, say_something/2]).

say_something(What, 0) ->
  done;
say_something(What, Times) ->
  io:format("~p~n", [What]),
  timer:sleep(100),
  say_something(What, Times - 1).

start() ->
  start(3).

start(N) ->
  spawn(?MODULE, say_something, [hello, N]),
  spawn(?MODULE, say_something, [goodbye, N]).
