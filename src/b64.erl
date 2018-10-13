%%%-------------------------------------------------------------------
%%% @author Ralf Thomas Pietsch <ratopi@abwesend.de>
%%% @copyright (C) 2018, Ralf Thomas Pietsch
%%% @doc
%%%  A stupid simple base64 encode ... 
%%%   0-25 'A'-'Z'
%%%  26-51 'a'-'z'
%%%  52-61 '0'-'9'
%%%  62-63 '+','/'
%%% @end
%%% Created : 13. Okt 2018 13:34
%%%-------------------------------------------------------------------
-module(b64).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([encode/1]).

encode(Binary) ->
	encode(Binary, []).

encode(<<>>, Acc) ->
	list_to_binary(lists:reverse(Acc));
encode(<<A:6, B:6, C:6, D:6, Rest/binary>>, Acc) ->
	List = [convert(D), convert(C), convert(B), convert(A) | Acc],
	encode(Rest, List);
encode(<<A:6, B:6, C:4, Rest/binary>>, Acc) ->
	List = [$=, convert(C), convert(B), convert(A) | Acc],
	encode(Rest, List);
encode(<<A:6, B:2, Rest/binary>>, Acc) ->
	List = [$=, $=, convert(B), convert(A) | Acc],
	encode(Rest, List).

convert(N) when N >= 0, N =< 25 ->
	N + 65;

convert(N) when N >= 26, N =< 51 ->
	N + 97;

convert(N) when N >= 52, N =< 61 ->
	N + 48;

convert(62) ->
	$+;

convert(63) ->
	$/.
