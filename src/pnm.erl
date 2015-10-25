%% Reading PNM-Image-Files
%% currently only P3 and P6 (untested) files are supported

-module(pnm).
-author("<ratopi@abwesend.de>").

-export([read/1, createImage/1]).

read(Filename) ->
	{ok, Bin} = file:read_file(Filename),
	createImage(Bin).

% ---

createImage(<<$P, $3, Bin/binary>>) ->
	{ok, [Width, Height, Depth], Rest} = nextAsciiNumbers(Bin, 3),
	Data = convertAsciiToImage(Width, Height, Rest, []),
	{image, {Width, Height}, {pnm, "P3", Depth}, Data};

createImage(<<$P, $6, Bin/binary>>) ->
	{ok, [Width, Height, Depth], Rest} = nextAsciiNumbers(Bin, 3),
	Data = convertNumbersToImage(Width, Height, Rest, []),
	{image, {Width, Height}, {pnm, "P3", Depth}, Data}.

% ---

convertNumbersToImage(_Width, 0, _Bin, Rows) ->
	Rows;
convertNumbersToImage(Width, Height, Bin, Rows) ->
	{ok, RowData, Rest} = readNumberRow(Width, [], Bin),
	convertNumbersToImage(Width, Height - 1, Rest, [RowData | Rows]).

readNumberRow(0, RowData, Bin) ->
	{ok, lists:reverse(RowData), Bin};
readNumberRow(Width, RowData, <<A, B, C, Rest/binary>>) ->
	readNumberRow(Width - 1, [[A, B, C] | RowData], Rest).

% ---

convertAsciiToImage(_Width, 0, _Bin, Rows) ->
	Rows;
convertAsciiToImage(Width, Height, Bin, Rows) ->
	{ok, RowData, Rest} = readAsciiRow(Width, Bin),
	convertAsciiToImage(Width, Height - 1, Rest, [RowData | Rows]).

readAsciiRow(Width, Bin) ->
	{ok, RowData, Rest} = readAsciiRow(Width, [], Bin),
	{ok, lists:reverse(RowData), Rest}.

readAsciiRow(0, RowData, Bin) ->
	{ok, RowData, Bin};
readAsciiRow(Width, RowData, Bin) ->
	{ok, Colors, Rest} = nextAsciiNumbers(Bin, 3),
	readAsciiRow(Width - 1, [Colors | RowData], Rest).

% ---

nextAsciiNumbers(Bin, N) ->
	nextAsciiNumbers(Bin, N, []).

nextAsciiNumbers(Bin, 0, Values) ->
	{ok, lists:reverse(Values), Bin};
nextAsciiNumbers(Bin, N, Values) ->
	{ok, TextValue, Rest} = nextWord(Bin),
	{Value, _} = string:to_integer(TextValue),
	nextAsciiNumbers(Rest, N - 1, [Value | Values]).

% ---

skipControlCharacters(<<$#, Rest/binary>>) ->
	skipControlCharacters(skipUntilLineFeed(Rest));
skipControlCharacters(<<32, Rest/binary>>) ->
	skipControlCharacters(Rest);
skipControlCharacters(<<Letter, Rest/binary>>) ->
	case chars:isControlCharacter(Letter) of
		true -> skipControlCharacters(Rest);
		false -> <<Letter, Rest/binary>>
	end.

% ---

skipUntilLineFeed(<<Letter, Rest/binary>>) ->
	case chars:isLineFeed(Letter) of
		false -> skipUntilLineFeed(Rest);
		true -> Rest
	end.

% ---

nextWord(Bin) ->
	{ok, Acc, Rest} = assembleWord(skipControlCharacters(Bin), []),
	{ok, lists:reverse(Acc), Rest}.

assembleWord(<<>>, Acc) ->
	{ok, Acc, <<>>};
assembleWord(<<Letter, Rest/binary>>, Acc) ->
	M = {Letter, chars:isControlCharacter(Letter)},
	case M of
		{32, _} -> {ok, Acc, Rest};
		{$#, _} -> {ok, Acc, Rest};
		{_, true} -> {ok, Acc, Rest};
		_ -> assembleWord(Rest, [Letter | Acc])
	end.
