%% zahlenraten
%% Guess a number!

-module(zahlenraten).
-export([run/0, nochmal/0]).

run() ->
  io:fwrite("Zahlenraten~n", []),
  io:fwrite("Erraten Sie eine Zahl zwischen 1 und 100~n", []),
  N = calculatenNumber(),
  % io:fwrite("Erraten Sie die Zahl '~p'~n", [N]),
  input(1, N).

calculatenNumber() ->
  random:uniform(100).

input(LOOP, N) ->
  io:fwrite("~nIhr ~p. Versuch: ", [LOOP]),
  {ok, [V]} = io:fread("> ", "~d"),
  io:fwrite("~nSie haben die Zahl ~p eingegeben~n", [V]),
  test(LOOP, N, V).

test(LOOP, N, N) ->
  io:fwrite("~n*** Zahl erraten! ***~nSie haben die Zahl mit ~p Versuchen erraten!~n~n", [LOOP]),
  nochmal();
test(LOOP, N, V) when V < N ->
  io:fwrite("Ihre Zahl ist zu klein!~n", []),
  input(LOOP + 1, N);
test(LOOP, N, V) when V > N ->
  io:fwrite("Ihre Zahl ist zu gross!~n", []),
  input(LOOP + 1, N);
test(LOOP, N, _) ->
  io:fwrite("~nLeider falsch. Versuchen Sie es weiter!~n", []),
  input(LOOP + 1, N).

nochmal() ->
  {ok, [C]} = io:fread("Wollen Sie nochmal? [J/N] ", "~c"),
  nochmal(C).

nochmal("j") ->
  run();
nochmal("J") ->
  run();
nochmal("n") ->
  io:fwrite("Tschuess~n", []);
nochmal("N") ->
  io:fwrite("Tschuess~n", []);
nochmal(_) ->
  io:fwrite("Ihre Eingabe war ungueltig!~n", []),
  nochmal().
