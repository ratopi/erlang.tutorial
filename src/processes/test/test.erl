%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 28. Aug 2016 18:30
%%%-------------------------------------------------------------------
-module(test).
-author("ratopi@abwesend.de").

%% API
-export([fork/1, get_state/1, change_state/2]).
-export([start/0]).

start() ->
	spawn(?MODULE, loop, [initial_state]).

loop(State) ->
	receive
		{fork, Sender} ->
			%%
			%% if you want to link with child process
			%% call spawn_link instead of spawn
			%%
			ClonePid = spawn(?MODULE, loop, [State]),
			responseTo(Sender, ClonePid),
			loop(State);

		{get_state, Sender} ->
			responseTo(Sender, {curr_state, State}),
			loop(State);

		{change_state, Data, Sender} ->
			{Response, NewState} = processData(Data, State),
			responseTo(Sender, Response),
			loop(NewState)
	end.

fork(Pid) ->
	Ref = make_ref(),
	Pid ! {fork, {Ref, self()}},
	get_response(Ref).

get_state(Pid) ->
	Ref = make_ref(),
	Pid ! {get_state, {Ref, self()}},
	get_response(Ref).

change_state(Pid, Data) ->
	Ref = make_ref(),
	Pid ! {change_state, Data, {Ref, self()}},
	get_response(Ref).

get_response(Ref) ->
	receive
		{Ref, Message} -> Message
	end.

responseTo({Ref, Pid}, Mes) ->
	Pid ! {Ref, Mes}.

processData(Data, State) ->
	%%
	%% here comes logic of processing data
	%% and changing process state
	%%
	NewState = Data,
	Response = {{old_state, State}, {new_state, NewState}},
	{Response, NewState}.
