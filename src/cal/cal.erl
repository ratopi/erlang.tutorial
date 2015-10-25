-module(cal).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([start/0, loop/0]).

start() ->
	spawn(?MODULE, loop, []).

loop() ->
	process_flag(trap_exit, true),
	receive
		{event, When, Object} ->
			cal_event:start(self(), When, Object),
			loop();
		{timed, Object} ->
			io:fwrite("timed ~p at ~p~n", [Object, cal_time:nowInSeconds()]),
			loop();
		shutdown ->
			io:fwrite("shutting down server~n");
		{'EXIT', _, normal} ->
			loop();
		{'EXIT', PID, Reason} ->
			io:fwrite("~p exit with reason {}~n", [PID, Reason]),
			loop();
		X ->
			io:fwrite("received ~p~n", [X]),
			loop()
	end.
