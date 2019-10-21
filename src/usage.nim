import strformat

proc usage*() =
  echo(&"""
Usage: notifier <command>

Commands:
- clear <localid>
  Retract a previously-sent message based on its local ID.

  Aliases: retract

  -l, --localid: Alternate format for specifying the local ID.

- auth
  Request an authentication token. Prompts for server URL and returns
  a username and password to be stored in environment variables.

- deauth
  Delete the current authentication token at the server. Future calls
  will fail until a new token has been requested using the auth command
  and the corresponding environment variables have been updated.

- send <arguments>
  Send a message to the notifier server using the credentials provided
  during auth.

  -b, --body      : Set the body of the outgoing message.
  -i, --badge     : Give the outgoing message a custom icon.
  -g, --group     : A tag or category assiged to the outgoing message.
  -l, --localid   : An ID to identify the outgoing message.
  -t, --title     : Set the title of the outgoing message.
  -u, --url       : Link the outgoing message to an external resource.

Aliases:
- authorize: auth
- retract  : clear

Miscellaneous:
-h, --help    : Display this message.
-v, --version : Display the version number.

""")
