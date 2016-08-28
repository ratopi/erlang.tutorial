%%%-------------------------------------------------------------------
%%% @author ratopi
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 28. Aug 2016 22:58
%%%-------------------------------------------------------------------
-module(client).
-author("ratopi").

%% API
-export([get/1, incr/1, decr/1]).

get(Pid) ->
	do(Pid, get).

incr(Pid) ->
	do(Pid, incr).

decr(Pid) ->
	do(Pid, decr).

do(Pid, Op) ->
	Ref = make_ref(),
	Pid ! {Op, {Ref, self()}},
	get_response(Ref).


get_response(Ref) ->
	receive
		{Ref, Message} -> Message
	after 1000 ->
		{error, timeout}
	end.
