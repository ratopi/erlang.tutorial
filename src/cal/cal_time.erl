-module(cal_time).
-author("<ratopi@abwesend.de>").

-export([nowInMicros/0, nowInMillis/0, nowInSeconds/0, nowInDays/0]).

nowInMicros() ->
	{Megas, Seconds, Micros} = os:timestamp(),
	(Megas * 1000000 + Seconds) * 1000000 + Micros.

nowInMillis() ->
	round(nowInMicros() / 1000).

nowInSeconds() ->
	round(nowInMicros() / 1000000).

nowInDays() ->
	round(nowInMicros() / (1000000 * 24 * 60 * 60)).
