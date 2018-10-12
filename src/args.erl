%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 02. Okt 2016 22:17
%%%-------------------------------------------------------------------
-module(args).
-author("ratopi@abwesend.de").

%% API
-export([test/2, test/3]).

test(A, B) ->
	io:fwrite("A: ~p B: ~p~n", [A, B]).

test(A, B, C) ->
	io:fwrite("A: ~p B: ~p C: ~p~n", [A, B, C]).
