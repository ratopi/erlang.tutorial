-module(pwgen).
-author("ratopi").

-export([generate_password/1]).

generate_password(N) ->
	lists:map(
		fun(_) ->
			random:uniform(90) + $\s + 1
		end,
		lists:seq(1, N)
	).
