%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%% A silly simple chat client: local API for controlling the local client process
%%% @end
%%% Created : 03. Sep 2016 15:49
%%%-------------------------------------------------------------------
-module(chat_client).
-author("ratopi@abwesend.de").

%% API
-export([login/0, logout/1, send/2]).


login() ->
	Client = start_transmitter(chatserver),
	send_with_ack(Client, login),
	Client.


send(Client, Message) ->
	send_with_ack(Client, {send, Message}),
	ok.


logout(Client) ->
	send_with_ack(Client, logout),
	send_with_ack(Client, shutdown),
	ok.

% ---

start_transmitter(ServerPid) ->
	CheckRef = make_ref(),
	Pid = spawn(chat_client_process, transmitter, [CheckRef, ServerPid]),
	{chatclient, CheckRef, Pid}.


send_with_ack(Client, Cmd) ->
	Ref = make_ref(),
	{chatclient, CheckRef, Pid} = Client,
	Pid ! {CheckRef, self(), Ref, Cmd},
	receive
		{Ref, ok} ->
			ok;
		{Ref, error, Reason} ->
			io:fwrite("~p failed with reason ~p~n", [Cmd, Reason]),
			{error, Reason}
	after 5000 ->
		timeout
	end.
