-module(cal_server).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([start/0, watchdog/0, loop/0]).

start() ->
	spawn(cal_server, watchdog, []).

watchdog() ->
	process_flag(trap_exit, true),
	PID = spawn(?MODULE, loop, []),
	register(?MODULE, PID),
	receive
		{'EXIT', _, normal} ->
			done;
		{'EXIT', PID, Reason} ->
			io:fwrite("server ~p exited:~n~n~p~n~n", [PID, Reason]),
			watchdog()
	end.

loop() ->
	process_flag(trap_exit, true),
	receive
		{event, When, Object} ->
			cal_event:start(self(), When, Object),
			loop();
		{timed, Object} ->
			io:fwrite("timed ~p at ~p~n", [Object, cal_time:nowInSeconds()]),
			loop();
		{ping, PID} ->
			PID ! pong;
		shutdown ->
			io:fwrite("shutting down server~n");
		{'EXIT', _, normal} ->
			loop();
		{'EXIT', PID, Reason} ->
			io:fwrite("~p exit with reason:~n~n~p~n~n", [PID, Reason]),
			loop();
		X ->
			io:fwrite("received ~p~n", [X]),
			loop()
	end.
