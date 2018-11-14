%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2018, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 13. Nov 2018 23:47
%%%-------------------------------------------------------------------
-module(perm2).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([perm/1, perm/2]).

perm([]) ->
	[[]];

perm(List) ->
	[[X | Y] || X <- List, Y <- perm(lists:delete(X, List))].



perm(List, FunOrPid) ->
	perm(List, List, FunOrPid).



perm([], _, _) ->
	ok;

perm([X | Rest], List, FunOrPid) ->
	Tails = perm(lists:delete(X, List)),
	send_lists(X, Tails, FunOrPid),
	perm(Rest, List, FunOrPid).



send_lists(_, [], _) ->
	ok;

send_lists(X, [Tail | Rest], FunOrPid) ->
	call([X | Tail], FunOrPid),
	send_lists(X, Rest, FunOrPid).



call(List, Pid) when is_pid(Pid) ->
	Pid ! {permutation, List};

call(List, Fun) when is_function(Fun, 1) ->
	Fun(List).
