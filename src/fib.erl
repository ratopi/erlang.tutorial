% No tutorial without Fibonacci

-module(fib).
-export([fib/1, tail/1]).

fib(0) ->
  1;
fib(1) ->
  1;
fib(N) ->
  fib(N - 1) + fib(N - 2).

tail(0) ->
  1;
tail(1) ->
  1;
tail(N) ->
  tail(0, 1, N).

tail(A, _, 0) ->
  A;
tail(A, B, N) ->
  tail(B, A+B, N-1).
