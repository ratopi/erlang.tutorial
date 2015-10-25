%%%-------------------------------------------------------------------
%%% @author Ralf Th. Pietsch
%%% @copyright (C) 2015, Ralf Th. Pietsch <ratopi@abwesend.de>
%%% @doc
%%%
%%% @end
%%% Created : 30. Sep 2015 10:37
%%%-------------------------------------------------------------------
-module(get).
-author("ratopi@abwesend.de").

%% API
-export([f/0]).

f() ->
  httpc:request("http://www.google.com").
