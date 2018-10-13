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
-export([encode/1, decode/1]).

encode(Binary) ->
	encode(Binary, []).

decode(Binary) ->
	decode(Binary, <<>>).


encode(<<>>, Acc) ->
	list_to_binary(lists:reverse(Acc));
encode(<<A:6, B:6, C:6, D:6, Rest/binary>>, Acc) ->
	List = [encode_6bit(D), encode_6bit(C), encode_6bit(B), encode_6bit(A) | Acc],
	encode(Rest, List);
encode(<<A:6, B:6, C:4, Rest/binary>>, Acc) ->
	List = [$=, encode_6bit(C), encode_6bit(B), encode_6bit(A) | Acc],
	encode(Rest, List);
encode(<<A:6, B:2, Rest/binary>>, Acc) ->
	List = [$=, $=, encode_6bit(B), encode_6bit(A) | Acc],
	encode(Rest, List).

encode_6bit(N) when N >= 0, N =< 25 ->
	N + $A;
encode_6bit(N) when N >= 26, N =< 51 ->
	N + $a;
encode_6bit(N) when N >= 52, N =< 61 ->
	N + $0;
encode_6bit(62) ->
	$+;
encode_6bit(63) ->
	$/.



decode(<<>>, Acc) ->
	Acc;
decode(<<A:8, B:8, C:8, D:8, Rest/binary>>, Acc) ->
	decode(Rest, <<Acc/binary, (decode_char(A)):6, (decode_char(B)):6, (decode_char(C)):6, (decode_char(D)):6>>).

decode_char(N) when N >= $A, N =< $Z ->
	N - $A;
decode_char(N) when N >= $a, N =< $z ->
	N - $a;
decode_char(N) when N >= $0, N =< $9 ->
	N - $0;
decode_char($+) ->
	62;
decode_char($/) ->
	63.
