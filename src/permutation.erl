%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2018, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 10. Nov 2018 16:47
%%%-------------------------------------------------------------------
-module(permutation).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([all/1]).


all([]) ->
	[];

all(L = [_]) ->
	[L];

all(List) ->
	starts(List, [], []).


starts([], _, Acc) ->
	Acc;

starts([H | Part2], Part1, Acc) ->
	Rest = Part1 ++ Part2,
	All = all(Rest),
	NewAcc = combine(H, All, Acc),
	starts(Part2, [H | Part1], NewAcc).


combine(_, [], Acc) ->
	Acc;

combine(H, [Tail | Tails], Acc) ->
	combine(H, Tails, [[H | Tail] | Acc]).
