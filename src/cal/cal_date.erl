-module(cal_date).
-author("<ratopi@abwesend.de>").

-export([start/2, run/2]).

start(PID, Entry) ->
	spawn(?MODULE, run, [PID, Entry]).

run(PID, Entry) ->
	{date, Name, WhenInSeconds} = Entry,
	Delay = WhenInSeconds - cal_time:nowInSeconds(),
	case Delay of
		N when N =< 0 ->
			PID ! {timed, Entry};
		N when N > 0 ->
			WaitDelay = Delay rem (49 * 24 * 60 * 60),
			io:fwrite("Will wait now ~p of ~p seconds~n", [WaitDelay, Delay]),
			receive
				{cancel, PID, Ref} ->
					PID ! {canceled, Ref}
			after
				WaitDelay ->
					run(PID, Entry)
			end
	end.
