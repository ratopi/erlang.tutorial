%%%-------------------------------------------------------------------
%%% @author Ralf Th. Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 08. Sep 2016 07:27
%%%-------------------------------------------------------------------
-module(link_test).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

%% API
-export([start/0, failing/0, not_failing/0]).

start() ->
	start(not_failing),
	start(failing).

start(F) ->
	process_flag(trap_exit, true),
	PID = spawn_link(?MODULE, F, []),
	io:fwrite("~nStarted ~w() in PID ~w~n", [F, PID]),
	receiving().

receiving() ->
	receive
		{'EXIT', PID, Reason} ->
			io:fwrite("~nPID ~w finished with reason:~n~w~n", [PID, Reason]);
		X ->
			io:fwrite("~nReceived~n~w~n", [X])
	after 10000 ->
		ok
	end.


failing() ->
	N = 1,
	D = 0,
	X = N / D.


not_failing() ->
	ok.
