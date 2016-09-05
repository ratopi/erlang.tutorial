%%%-------------------------------------------------------------------
%%% @author ratopi@abwesend.de
%%% @copyright (C) 2016, Ralf Th. Pietsch
%%% @doc
%%% A silly simple chat server.
%%% Start the server with:
%%% chat_server:start().
%%% @end
%%% Created : 03. Sep 2016 15:13
%%%-------------------------------------------------------------------
-module(chat_server).
-author("ratopi@abwesend.de").

%% API
-export([start/0, loop/1, control/1]).

% --- Public ---

start() ->
	StopRef = make_ref(),
	Pid = spawn(?MODULE, loop, [{StopRef, []}]),
	register(chatserver, Pid),
	{ok, StopRef, Pid}.


% ---


control({shutdown, StopRef}) ->
	chatserver ! {self(), make_ref(), {shutdown, StopRef}}.


% ---


loop({StopRef, Clients}) ->

	receive

		{Pid, Ref, Cmd} ->

			case Cmd of
				login ->
					{ok, NewClients} = login(Clients, Pid, Ref),
					loop({StopRef, NewClients});

				logout ->
					{ok, NewClients} = logout(Clients, Pid, Ref),
					loop({StopRef, NewClients});

				{message, Message} ->
					send_message(Clients, Message),
					Pid ! {Ref, ok},
					loop({StopRef, Clients});

				{shutdown, StopRef} ->
					send(Clients, notify, shuttingdown, Ref),
					io:fwrite("shutting down ...~n");

				X ->
					send(Pid, Ref, {error, {badarg, X}})

			end;

		X ->
			io:fwrite("Received unknown value:~n~p~n", [X])

	end.


% ---


login(Clients, Client, Ref) ->
	case set:add(Client, Clients) of
		{added, NewClients} ->
			Client ! {Ref, ok},
			{ok, NewClients};
		{nomod, Clients} ->
			Client ! {Ref, {error, alreadyloggedin}},
			{ok, Clients}
	end.


logout(Clients, Client, Ref) ->
	case set:remove(Client, Clients) of
		{removed, NewClients} ->
			Client ! {Ref, ok},
			{ok, NewClients};
		{nomod, Clients} ->
			Client ! {Ref, {error, notloggedin}},
			{ok, Clients}
	end.




send_message([], _) ->
	ok;

send_message([Client | Clients], Message) ->
	Client ! {broadcast, Message},
	send_message(Clients, Message).



send(Clients, Message, Ref) ->
	send(Clients, message, Message, Ref).



send([], _, _, _) ->
	done;

send([Client | Clients], Type, Message, Ref) ->
	Client ! {Ref, Type, Message},
	send(Clients, Message, Ref);

send(Client, Type, Message, Ref) ->
	Client ! {Ref, Type, Message}.
