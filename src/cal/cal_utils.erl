-module(cal_utils).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([uuid/0, uuid/1]).

uuid() ->
	uuid(32).

uuid(N) ->
	uuid(N, []).

uuid(0, Acc) ->
	lists:reverse(Acc);
uuid(N, Acc) ->
	uuid(N - 1, [digit() | Acc]).

digit() ->
	N = (random:uniform(16) - 1) + $0,
	if
		N > $9 -> N - $9 + $a - 1;
		true -> N
	end.
