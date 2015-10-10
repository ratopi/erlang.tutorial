% No tutorial without Fibonacci

-module(fib).
-export([fib/1, tail/1]).

fib(1) ->
  1;
fib(2) ->
  1;
fib(N) when N > 0 ->
  fib(N - 1) + fib(N - 2).

tail(1) ->
  1;
tail(2) ->
  1;
tail(N) when N > 0 ->
  tail(0, 1, N).

tail(A, _, 0) ->
  A;
tail(A, B, N) ->
  tail(B, A + B, N - 1).
