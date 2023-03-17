import strformat

proc usage*() =
  echo(&"""
Usage: notifier <command>

Commands:
clear <localid>
  Retract a previously-sent message based on its local ID.

  -l, --localid: Alternate format for specifying the local ID.
  -v, --verbose: Display debugging messages about the HTTP request.

  Aliases: retract

auth
  Request an authentication token. Prompts for server URL, username, and
  password. Writes the authentication token to ~/.config/notifier.ini

  Aliases: authorize

deauth
  Delete the current authentication token at the server. Future calls
  will fail until a new token has been requested using the auth command.

send <arguments>
  Send a message to the notifier server using the credentials provided
  during auth.

  -b, --body          : Set the body of the outgoing message.
  -d, --deliverystyle : If "whisper", equivalent to that command.
  -e, --expires       : Auto-clear the message at a future point in time
                        relative to the send time. Specified as one or more
                        number-and-label pairs. Label can be "seconds",
                        "minutes", "hours", or "days". Example: "30 minutes".
  -i, --badge         : Give the outgoing message a custom icon.
  -g, --group         : A tag or category assiged to the outgoing message.
  -l, --localid       : An ID to identify the outgoing message.
  -t, --title         : Set the title of the outgoing message.
  -u, --url           : Link the outgoing message to an external resource.
  -v, --verbose       : Display debugging messages about the HTTP request.

whisper <arguments>
  Same as send, except the message will not be relayed to
  webhooks. Use this to send messages to the server and connected
  clients, but no further.

Miscellaneous:
-h, --help    : Display this message.
-v, --version : Display the version number.

""")
