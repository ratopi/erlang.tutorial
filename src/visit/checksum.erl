%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 30. Aug 2016 22:57
%%%-------------------------------------------------------------------
-module(checksum).
-author("ratopi@abwesend.de").

%% API
-export([]).

-export([start/0, receiver/0]).

start() ->
	spawn(?MODULE, receiver, []).

receiver() ->
	receive
		{regular, Path} ->
			MD5 = os:cmd("md5sum " ++ Path),
			io:fwrite("~s", [MD5]);
		_ ->
			ignored
	end,
	receiver().
