-module(chars).
-author("<ratopi@abwesend.de").

%% API
-export([isControlCharacter/1, isLineFeed/1]).

isControlCharacter(Letter) when Letter < 32 ->
	true;
isControlCharacter(127) ->
	true;
isControlCharacter(_) ->
	false.

isLineFeed(10) ->
	true;
isLineFeed(13) ->
	true;
isLineFeed(_) ->
	false.
