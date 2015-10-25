-module(cal_event).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([start/3, run/3]).

start(PID, WhenInSeconds, Object) ->
	spawn(?MODULE, run, [PID, WhenInSeconds, Object]).

run(PID, WhenInSeconds, Object) ->
	Delay = WhenInSeconds - cal_time:nowInSeconds(),
	case Delay of
		N when N =< 0 ->
			PID ! {timed, Object};
		N when N > 0 ->
			WaitDelay = (Delay rem (49 * 24 * 60 * 60)) * 1000,
			receive
				{cancel, PID, Ref} ->
					PID ! {canceled, Ref}
			after
				WaitDelay ->
					run(PID, WhenInSeconds, Object)
			end
	end.
