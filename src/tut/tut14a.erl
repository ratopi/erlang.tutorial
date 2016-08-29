%
% Modified Example from http://www.erlang.org/doc/getting_started/conc_prog.html
%

-module(tut14a).

-export([start/0, start/1, start/2, say_something/3]).


say_something(N, What, Wait) ->
	timer:sleep(Wait),
	io:format("~w. ~p after ~w ms ... ENDED~n", [N, What, Wait]).


start() ->
	start(3).


start(N) ->
	start(N, hello),
	start(N, goodbye).


start(0, _) ->
	done;

start(N, What) ->
	spawn(?MODULE, say_something, [N, What, random:uniform(3000)]),
	start(N - 1, What).
