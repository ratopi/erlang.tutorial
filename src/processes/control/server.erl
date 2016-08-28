%%%-------------------------------------------------------------------
%%% @author ratopi
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 28. Aug 2016 22:09
%%%-------------------------------------------------------------------
-module(server).
-author("ratopi").

%% API
-export([start/0, loop/0]).

start() ->
	{ok, spawn(?MODULE, loop, [])}.

loop() ->
	loop({0}).

loop(State) ->
	receive
		{get, Sender} ->
			responseTo(Sender, {curr_state, State}),
			loop(State);

		{print, Sender} ->
			io:fwrite("~w~n", [State]),
			responseTo(Sender, {curr_state, State}),
			loop(State);

		{incr, Sender} ->
			NewState = incr(State),
			responseTo(Sender, {curr_state, NewState}),
			loop(NewState);

		{decr, Sender} ->
			NewState = decr(State),
			responseTo(Sender, {curr_state, NewState}),
			loop(NewState);

		{stop, Sender} ->
			io:fwrite("~w stopped~n", [self()]),
			responseTo(Sender, {curr_state, State})
	end.

incr({N}) ->
	{N + 1}.

decr({N}) ->
	{N - 1}.

% ---

responseTo({Ref, Pid}, Mes) ->
	Pid ! {Ref, Mes}.
