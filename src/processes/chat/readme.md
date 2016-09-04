This is a stupid silly simple chat-server and -client.

This is not intended to be use in production, but is done for the purpose of learning erlang.


# Protocol

## Generals

From client to server first parameter is Pid, second is unique Ref.
Third parameter is the command (always an atom or a tuple starting with an atom):

	{ Pid, Ref, <atom> }
	{ Pid, Ref, { <atom>, ... } }

Therefore this pattern matches always:

	{ Pid, Ref, Cmd }

From server to client first parameter is Ref (from client).
Second parameter is the response code (always an atom):

	{ Ref, <atom> }
	{ Ref, { <atom>, Cmd } }

Therefore this pattern matches always:

	{ Ref, Response }

Broadcasts from server to all clients are delivered without a Ref, instead the atom broadcast is used:

	{ broadcast, Response }


## Login

Client -> Server

	{ Pid, Ref, login }

Server -> Client

	{ Ref, { notify, welcome } }

or

	{ Ref, { notify, alreadyloggedin } }


## Message

Client -> Server

	{ Pid, Ref, { message, Message } }

Server -> Client

	{ Ref, ok }

An the distribution of the message itself to all Clients in current chat:

	{ Ref, message, Message }


## Logout

Client -> Server

	{ Pid, Ref, logout }

Server -> Client

	{ Ref, loggedout }

or

	{ Ref, { error, notloggedin } }


## Shutdown

Client -> Server

	{ Pid, Ref, { shutdown, ShutDownRef } }

Server -> Client

	{ Ref, shuttingdown }

To all Clients

	{ broadcast, shuttingdown }
