%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2018, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 11. Nov 2018 07:25
%%%-------------------------------------------------------------------
-module(fac).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([fac/1, fac_d/1]).

fac(N) ->
	fac(N, 1).


fac(0, Acc) ->
	Acc;

fac(1, Acc) ->
	Acc;

fac(N, Acc) ->
	fac(N - 1, Acc * N).


fac_d(0) ->
	1;
fac_d(1) ->
	1;
fac_d(N) ->
	N * fac_d(N - 1).
