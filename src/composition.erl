%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2018, Ralf Thomas Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 12. Okt 2018 06:36
%%%-------------------------------------------------------------------
-module(composition).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([composition/1]).



composition(ListOfFuns) ->
	fun(Value) ->
		exec_composition(ListOfFuns, Value)
	end.


exec_composition([], Value) ->
	Value;
exec_composition([H | T], Value) ->
	exec_composition(T, H(Value)).



composition_2(ListOfFuns) ->
	fun(Value) ->
		lists:foldl(
			fun(Elem, Acc) ->
				Elem(Acc)
			end,
			Value,
			ListOfFuns
		)
	end.
