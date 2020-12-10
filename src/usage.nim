import strformat

proc usage*() =
  echo(&"""
Usage: notifier <command>

Commands:
- clear <localid>
  Retract a previously-sent message based on its local ID.

  Aliases: retract

  -l, --localid: Alternate format for specifying the local ID.
  -v, --verbose: Display debugging messages about the HTTP request.

- auth
  Request an authentication token. Prompts for server URL, username, and
  password. Writes the authentication token to ~/.config/notifier.ini

- deauth
  Delete the current authentication token at the server. Future calls
  will fail until a new token has been requested using the auth command.

- send <arguments>
  Send a message to the notifier server using the credentials provided
  during auth.

  -b, --body          : Set the body of the outgoing message.
  -d, --deliverystyle : If "whisper", equivalent to that command.
  -i, --badge         : Give the outgoing message a custom icon.
  -g, --group         : A tag or category assiged to the outgoing message.
  -l, --localid       : An ID to identify the outgoing message.
  -t, --title         : Set the title of the outgoing message.
  -u, --url           : Link the outgoing message to an external resource.
  -v, --verbose       : Display debugging messages about the HTTP request.

- whisper <arguments>
  Same as send, except the message will not be relayed to
  webhooks. Use this to send messages to the server and connected
  clients, but no further.

Aliases:
- authorize: auth
- retract  : clear

Miscellaneous:
-h, --help    : Display this message.
-v, --version : Display the version number.

""")
