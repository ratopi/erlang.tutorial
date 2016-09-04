%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%% A silly simple chat client
%%% @end
%%% Created : 03. Sep 2016 15:49
%%%-------------------------------------------------------------------
-module(chat_client).
-author("ratopi@abwesend.de").

%% API
-export([login/0, logout/0, send/1]).
-export([consume_anything/0]).

login() ->
	Ref = make_ref(),

	chatserver ! {self(), Ref, login},

	receive

		{Ref, {notify, welcome}} ->
			loggedin;

		{Ref, {notify, alreadyloggedin}} ->
			alreadyloggedin;

		{Ref, {error, Reason}} ->
			io:fwrite("Login failed: ~p~n", [Reason])

	after 5000 ->
		timeout

	end.

send(Message) ->
	Ref = make_ref(),
	chatserver ! {self(), Ref, {message, Message}},
	ok.

logout() ->
	Ref = make_ref(),
	chatserver ! {self(), Ref, logout},
	ok.



consume_anything() ->
	receive
		X ->
			io:fwrite("Received: ~p~n", [X]),
			consume_anything()
	after
		0 ->
			nothing
	end.
