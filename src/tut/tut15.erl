%
% Modified Example from http://www.erlang.org/doc/getting_started/conc_prog.html
%

-module(tut15).

-export([start/0, ping/3, pong/0]).

start() ->
  Pong_PID = spawn(tut15, pong, []),
  spawn(tut15, ping, [15, Pong_PID, 300]),
  spawn(tut15, ping, [15, Pong_PID, 200]).


ping(0, Pong_PID, _) ->
  Pong_PID ! finished,
  io:format("ping finished~n", []);

ping(N, Pong_PID, Delay) ->
  Pong_PID ! {ping, self(), N},
  receive
    {pong, PID, M} ->
      io:format("~p received ~p. pong from ~p~n", [self(), M, PID])
  end,
  timer:sleep(Delay),
  ping(N - 1, Pong_PID, Delay).


pong() ->
  receive
    finished ->
      io:format("Pong finished~n", []);
    {ping, Ping_PID, N} ->
      io:format("Pong received ~p. ping from ~p ~n", [N, Ping_PID]),
      Ping_PID ! {pong, self(), N},
      pong()
  end.
