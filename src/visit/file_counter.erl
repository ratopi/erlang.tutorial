%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%%
%%% @end
%%% Created : 30. Aug 2016 22:36
%%%-------------------------------------------------------------------
-module(file_counter).
-author("ratopi@abwesend.de").

%% API
-export([start/0, receiver/2]).

start() ->
	spawn(?MODULE, receiver, [0, 0]).

receiver(FileCount, DirCount) ->
	receive
		{regular, Path} ->
			io:format("~w    ~s is a file~n", [FileCount + 1, Path]),
			receiver(FileCount + 1, DirCount);
		{directory, Path} ->
			io:format("   ~w ~s is a directory~n", [DirCount + 1, Path]),
			receiver(FileCount, DirCount + 1);
		X ->
			io:format("~w IGNORED~n", [X]),
			receiver(FileCount, DirCount)
	end.


%%visitFile(regular, Path) ->
%%	io:fwrite("~s is a file!~n", [Path]);
%%
%%visitFile(directory, Path) ->
%%	io:fwrite("~s is a directory!~n", [Path]),
%%	visit(Path ++ "/");
%%
%%visitFile(_, Path) ->
%%	io:fwrite("~s is something else!~n", [Path]).
