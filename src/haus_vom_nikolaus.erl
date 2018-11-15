%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2018, Ralf Thomas Pietsch
%%% @doc
%%%
%%% Berechnet alle Möglichkeiten, daß "Haus vom Nikolaus" zu zeichnen.
%%%
%%% Die Punkte sind folgendermaßen angeordnet:
%%%
%%%     c
%%%   b   d
%%%   a   e
%%%
%%% @end
%%% Created : 05. Nov 2018 19:26
%%%-------------------------------------------------------------------
-module(haus_vom_nikolaus).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([]).
-compile(export_all).
-on_load(loaded/0).


-define(LINE_D(Line), {line, Line}).
-define(EOT, eot).
-define(IGNORE, ignore).


loaded() ->
	io:fwrite("Hello, World!~n").


test() ->
	CollectorPid = spawn(?MODULE, collector, []),
	FilterPid = spawn(?MODULE, filter_receiver, [CollectorPid]),
	PermutatorPid = spawn(?MODULE, permutator, [FilterPid]),
	all_lines(PermutatorPid).


collector() ->
	Start = erlang:system_time(millisecond),
	collector(Start, 0, 0).

collector(Start, N, Total) ->
	receive
		?EOT ->
			io:fwrite("received ~p of ~p combinations~n", [N, Total]),
			io:fwrite("~p~n", [erlang:system_time(millisecond) - Start]);
		?IGNORE ->
			collector(Start, N, Total + 1);
		?LINE_D(Line) ->
			io:fwrite("~p : ~p~n", [N, Line]),
			collector(Start, N + 1, Total + 1);
		X ->
			io:fwrite("Received Nonsense : ~p~n", [X]),
			collector(Start, N, Total)
	end.


filter_receiver(Pid) ->
	receive
		?EOT ->
			Pid ! ?EOT;
		R = ?LINE_D(Line) ->
			case lines_connected(Line) of
				true ->
					Pid ! R;
				false ->
					Pid ! ?IGNORE
			end,
			filter_receiver(Pid)
	end.


all_lines(Pid) ->
	send_lines(Pid, [reverse_lines(<<N>>, lines()) || N <- lists:seq(0, 255)]),
	Pid ! ?EOT,
	ok.


permutator(Pid) ->
	receive
		?EOT ->
			Pid ! ?EOT;
		?LINE_D(Line) ->
			perm2:perm(
				Line,
				fun(L) ->
					Pid ! ?LINE_D(L)
				end
			),
			permutator(Pid)
	end.


reverse_lines(<<A:1, B:1, C:1, D:1, E:1, F:1, G:1, H:1>>, Lines) ->
	[
		reverse_line_on_demand(A, lists:nth(1, Lines)),
		reverse_line_on_demand(B, lists:nth(2, Lines)),
		reverse_line_on_demand(C, lists:nth(3, Lines)),
		reverse_line_on_demand(D, lists:nth(4, Lines)),
		reverse_line_on_demand(E, lists:nth(5, Lines)),
		reverse_line_on_demand(F, lists:nth(6, Lines)),
		reverse_line_on_demand(G, lists:nth(7, Lines)),
		reverse_line_on_demand(H, lists:nth(8, Lines))
	].


reverse_line_on_demand(0, Line) ->
	Line;
reverse_line_on_demand(1, Line) ->
	reverse_line(Line).


reverse_line({A, B}) ->
	{B, A}.


send_lines(Pid, []) ->
	ok;
send_lines(Pid, [H | Rest]) ->
	Pid ! ?LINE_D(H),
	send_lines(Pid, Rest);

send_lines(Pid, Lines) ->
	[(Pid ! ?LINE_D(L)) || L <- Lines].


lines_connected([_]) ->
	true;
lines_connected([A, B | T]) ->
	case line_connected(A, B) of
		false ->
			false;
		true ->
			lines_connected([B | T])
	end.



line_connected({_, A}, {A, _}) ->
	true;
line_connected(_, _) ->
	false.


lines() ->
	[
		{a, b},
		{a, d},
		{a, e},
		{b, c},
		{b, d},
		{b, e},
		{c, d},
		{d, e}
	].
