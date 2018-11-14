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
-export([perm/1]).

perm([]) ->
	[[]];

perm(List) ->
	[[X | Y] || X <- List, Y <- perm(lists:delete(X, List))].
