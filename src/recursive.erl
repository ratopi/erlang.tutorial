-module(recursive).
-author("ratopi@abwesend.de").

-export([build/2, buildIndex/1, length/1, zip/2]).

%---

build(N, E) ->
  build(N, E, []).

build(0, _, L) ->
  L;
build(N, E, L) ->
  build(N - 1, E, [E | L]).

%---

buildIndex(N) ->
  buildIndex(N, []).

buildIndex(0, L) ->
  L;
buildIndex(N, L) ->
  buildIndex(N - 1, [N | L]).

%---

length(L) ->
  length(0, L).

length(N, []) ->
  N;
length(N, [_ | T]) ->
  length(N + 1, T).

%---

zip(N, L) ->
  zip(N, L, []).

zip(0, _, Target) ->
  Target;
zip(_, [], Target) ->
  Target;
zip(N, [H | Source], Target) ->
  zip(N - 1, Source, Target ++ [H]).
