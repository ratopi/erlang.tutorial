% Berechnet den größten gemeinsamen Teiler
-module(ggt).
-author("Ralf Thomas Pietsch <ratopi@abwesend.de>").

%% API
-export([ggt/2]).

ggt(A, B) when A < B ->
	ggt(B, A);

ggt(A, A) ->
	A;

ggt(_, 1) ->
	1;

ggt(A, 0) ->
	A;

ggt(A, B) when A > B ->
	ggt(A - B, B).
