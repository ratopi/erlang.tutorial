-module(cal_event).
-author("Ralf Th. Pietsch <ratopi@abwesend.de>").

-export([start/2]).

start(PID, Event) ->
	spawn(?MODULE, run, [PID, Event]).

run(PID, Event) ->
	{date, _Name, WhenInSeconds} = Event,
	Delay = WhenInSeconds - cal_time:nowInSeconds(),
	case Delay of
		N when N =< 0 ->
			PID ! {timed, Event};
		N when N > 0 ->
			WaitDelay = Delay rem (49 * 24 * 60 * 60),
			io:fwrite("Will wait now ~p of ~p seconds~n", [WaitDelay, Delay]),
			receive
				{cancel, PID, Ref} ->
					PID ! {canceled, Ref}
			after
				WaitDelay ->
					run(PID, Event)
			end
	end.
