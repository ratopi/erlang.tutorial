-module(cal).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([start/0, event/2]).

start() ->
	cal_server:start().

event(When, Object) ->
	whereis(cal_server) ! {event, When, Object}.
