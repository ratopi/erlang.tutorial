-module(cal_time).
-author("<ratopi@abwesend.de>").

-export([nowInNano/0, nowInMicros/0, nowInMillis/0, nowInSeconds/0, nowInDays/0]).

nowInNano() ->
	erlang:system_time(nano_seconds).

nowInMicros() ->
	erlang:system_time(micro_seconds).

nowInMillis() ->
	erlang:system_time(milli_seconds).

nowInSeconds() ->
	erlang:system_time(seconds).

nowInDays() ->
	round(nowInSeconds() / (24 * 60 * 60)).
