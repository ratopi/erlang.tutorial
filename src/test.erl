-module(test).
-author("Pietsch_R").

-export([test/0, test/1]).

test() ->
	test(1000000).

test(N) ->
	test(N, 16#10000, 0).

test(0, Min, Max) ->
	{Min, Max};
test(N, 0, 16#FFFF) ->
	{N};
test(N, Min, Max) ->
	Val = random:uniform(16#10000) - 1,
	{NewMin, NewMax} = analyse(Val, Min, Max),
	test(N - 1, NewMin, NewMax).

analyse(Val, Min, Max) when Val < Min, Val > Max ->
	{Val, Val};
analyse(Val, Min, Max) when Val < Min ->
	{Val, Max};
analyse(Val, Min, Max) when Val > Max ->
	{Min, Val};
analyse(_, Min, Max) ->
	{Min, Max}.
