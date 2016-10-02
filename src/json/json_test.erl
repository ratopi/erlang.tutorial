%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 02. Okt 2016 18:33
%%%-------------------------------------------------------------------
-module(json_test).
-author("ratopi@abwesend.de").

%% API
-export([test/0]).

test() ->
	io:fwrite("~n"),
	test(<<"Hallo">>),
	test([{a, <<"Ciao">>}]),
	test({struct, [{hello, <<"Hallo">>}]}),
	test([a,b,c,d]).

test(O) ->
	JSON = mochijson2:encode(O),
	io:fwrite("~w~n->~n~s~n~n", [O, JSON]).
