%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%% A silly simple chat client: local process for handling messages ...
%%% @end
%%% Created : 03. Sep 2016 15:49
%%%-------------------------------------------------------------------
-module(chat_client_process).
-author("ratopi@abwesend.de").

%% API
-export([transmitter/2]).


transmitter(CheckRef, ServerPid) ->
	io:fwrite("Starting client processor~n"),
	transmitter({CheckRef, ServerPid}).


transmitter({CheckRef, ServerPid}) ->
	receive

		{CheckRef, Pid, ClientRef, shutdown} ->
			Pid ! {ClientRef, ok},
			io:fwrite("shutting down...");

		{CheckRef, Pid, ClientRef, Cmd} ->
			handle_local_command(Pid, ClientRef, Cmd),
			transmitter({CheckRef, ServerPid});

		{broadcast, Response} ->
			io:fwrite("C: < ~p~n", [Response]),
			transmitter({CheckRef, ServerPid});

		X ->
			io:fwrite("C: Received nonsense: ~p~n", [X]),
			transmitter({CheckRef, ServerPid})

	end.


handle_local_command(Pid, ClientRef, login) ->
	send_cmd(Pid, ClientRef, login);


handle_local_command(Pid, ClientRef, logout) ->
	send_cmd(Pid, ClientRef, logout);


handle_local_command(Pid, ClientRef, {send, Message}) ->
	send_cmd(Pid, ClientRef, {message, Message}).


send_cmd(Pid, ClientRef, Cmd) ->
	ServerRef = make_ref(),
	chatserver ! {self(), ServerRef, Cmd},
	receive
		{ServerRef, ok} ->
			Pid ! {ClientRef, ok},
			ok;
		{ServerRef, {error, Reason}} ->
			Pid ! {ClientRef, error, Reason},
			io:fwrite("~p failed: ~p~n", [Cmd, Reason]),
			{error, Reason}
	after 5000 ->
		timeout
	end.
