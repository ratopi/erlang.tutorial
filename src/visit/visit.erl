%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%% Traverse a file tree and call a visit function for each file.
%%% @end
%%% Created : 30. Aug 2016 19:28
%%%-------------------------------------------------------------------
-module(visit).
-author("ratopi@abwesend.de").

-include_lib("kernel/include/file.hrl").

%% API
-export([visit/2]).

visit(Dir, Pid) ->

	case file:list_dir_all(Dir) of

		{ok, Files}
			-> visit(Dir, Files, Pid);

		{error, Reason}
			-> io:fwrite("Can not visit ~s due to a ~w~n", [Dir, Reason])

	end.



visit(Path, [H | T], Pid) ->
	FullPath = Path ++ H,
	{ok, FileInfo} = file:read_file_info(FullPath),
	Type = FileInfo#file_info.type,
	Pid ! {Type, FullPath},
	deeper(Type, FullPath, Pid),
	visit(Path, T, Pid);

visit(_, [], _) ->
	done.


deeper(directory, Path, Pid) ->
    visit(Path ++ "/", Pid);

deeper(_, _, _) ->
	ignored.
