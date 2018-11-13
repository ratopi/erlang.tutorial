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
-export([perm/1, without/2]).

perm([]) ->
	[];

perm(L=[_]) ->
	[L];

perm(List) ->
	[[X | Y] || X <- List, Y <- perm(without(X, List))].


without(X, List) ->
	lists:filter(
		fun(E) -> X /= E end,
		List
	).
