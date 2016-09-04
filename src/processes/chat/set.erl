%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%% A silly simple lib for handling list with unique values in it.
%%% @end
%%% Created : 04. Sep 2016 15:02
%%%-------------------------------------------------------------------
-module(set).
-author("ratopi@abwesend.de").

%% API
-export([add/2, remove/2, contains/2]).

% ---

add(O, Set) ->
	case add(O, Set, []) of
		alreadyin ->
			{nomod, Set};
		{added, NewSet} ->
			{added, NewSet}
	end.



add(O, [O | _Tail], _Rest) ->
	alreadyin;

add(O, [], Rest) ->
	{added, [O | Rest]};

add(O, [H | T], Rest) ->
	add(O, T, [H | Rest]).

% ---

remove(O, Set) ->
	case remove(O, Set, []) of
		notin ->
			{nomod, Set};
		{removed, NewSet} ->
			{removed, NewSet}
	end.



remove(O, [O | Tail], Rest) ->
	{removed, Tail ++ Rest};

remove(_O, [], _Rest) ->
	notin;

remove(O, [H | T], Rest) ->
	remove(O, T, [H | Rest]).


%--

contains(O, [O | _Tail]) ->
	in;

contains(_O, []) ->
	notin;

contains(O, [_H | T]) ->
	contains(O, T).
