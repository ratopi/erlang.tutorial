-module(cal_event).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([start/3]).

start(PID, When, Object) ->
	spawn(?MODULE, run, [PID, When, Object]).

run(PID, WhenInSeconds, Object) ->
	Delay = WhenInSeconds - cal_time:nowInSeconds(),
	case Delay of
		N when N =< 0 ->
			PID ! {timed, Object};
		N when N > 0 ->
			WaitDelay = Delay rem (49 * 24 * 60 * 60),
			io:fwrite("Will wait now ~p of ~p seconds~n", [WaitDelay, Delay]),
			receive
				{cancel, PID, Ref} ->
					PID ! {canceled, Ref}
			after
				WaitDelay ->
					run(PID, WhenInSeconds, Object)
			end
	end.
