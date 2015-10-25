%% Reading PNM-Image-Files
%% currently only P3 files are supported

-module(pnm).
-author("<ratopi@abwesend.de>").

-export([read/1, createImage/1]).

read(Filename) ->
	{ok, Bin} = file:read_file(Filename),
	createImage(Bin).

% ---

createImage(<<$P, $3, Bin/binary>>) ->
	{ok, WidthText, R1} = nextWord(Bin),
	{ok, HeightText, R2} = nextWord(R1),
	{ok, DepthText, Rest} = nextWord(R2),

	{Width, _} = string:to_integer(WidthText),
	{Height, _} = string:to_integer(HeightText),
	{Depth, _} = string:to_integer(DepthText),

	Data = convertAsciiToImage(Width, Height, Rest, []),
	{image, {Width, Height}, {pnm, "P3", Depth}, Data}.

% ---

convertAsciiToImage(_Width, 0, _Bin, Rows) ->
	Rows;
convertAsciiToImage(Width, Height, Bin, Rows) ->
	{ok, RowData, Rest} = readAsciiRow(Width, Bin),
	convertAsciiToImage(Width, Height - 1, Rest, [RowData | Rows]).

% ---

readAsciiRow(Width, Bin) ->
	{ok, RowData, Rest} = readAsciiRow(Width, [], Bin),
	{ok, lists:reverse(RowData), Rest}.

readAsciiRow(0, RowData, Bin) ->
	{ok, RowData, Bin};
readAsciiRow(Width, RowData, Bin) ->
	{ok, Colors, Rest} = nextColorTuple(Bin),
	readAsciiRow(Width - 1, [Colors | RowData], Rest).

% ---

nextColorTuple(Bin) ->
	nextColorTuple(Bin, 3, []).

nextColorTuple(Bin, 0, Values) ->
	{ok, lists:reverse(Values), Bin};
nextColorTuple(Bin, N, Values) ->
	{ok, TextValue, Rest} = nextWord(Bin),
	{Value, _} = string:to_integer(TextValue),
	nextColorTuple(Rest, N - 1, [Value | Values]).

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
