-module(cal_utils).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([uuid/0, uuid/1]).

uuid() ->
	uuid(32).

uuid(N) when is_integer(N) ->
	uuid(N, []).

uuid(0, Acc) ->
	lists:reverse(Acc);
uuid(N, Acc) ->
	uuid(N - 1, [digit() | Acc]).

digit() ->
	N = (random:uniform(16) - 1),
	if
		N < 10 -> N + $0;
		N >= 10 -> N + $a - 10
	end.
