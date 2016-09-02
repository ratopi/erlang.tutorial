%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 31. Aug 2016 21:37
%%%-------------------------------------------------------------------
-module(alot).
-author("ratopi@abwesend.de").

%% API
-export([start/1, run/3, registrar/1]).


start(N) ->
	Pid = spawn(?MODULE, registrar, [0]),
	startRun(N, N, Pid).


startRun(0, _, _) ->
	done;

startRun(N, Total, Pid) ->
	W = random:uniform(1000),
	spawn(?MODULE, run, [N, W, Pid]),
	startRun(N - 1, Total, Pid).


run(N, W, Pid) ->
	Pid ! {started, N},
	timer:sleep(W),
	Pid ! {terminated, N}.


registrar(Total) ->
	receive
		{terminated, N} ->
			io:fwrite("#~w/~w terminated~n", [N, Total]),
			registrar(Total - 1);
		{started, N} ->
			io:fwrite("#~w/~w started~n", [N, Total + 1]),
			registrar(Total + 1)
	end.
