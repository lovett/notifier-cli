import os, parseopt
import authorize, clear, client, deauthorize, send, usage, version

if paramCount() == 0:
  usage()

for kind, key, value in getOpt():
  case kind
  of cmdArgument:
    case key
    of "auth", "authorize":
      authorize()
      break
    of "clear", "retract":
      let (client, base) = makeClient()
      clear(client, base)
      break
    of "deauth", "deauthorize":
      let (client, base) = makeClient()
      deauthorize(client, base)
      break
    of "help":
      usage()
      break
    of "send":
      let (client, base) = makeClient()
      send(client, base)
      break
    of "version":
      version()
      break
    of "whisper":
      let (client, base) = makeClient()
      whisper(client, base)
      break
    else:
      quit("Invalid command")
  of cmdLongOption, cmdShortOption:
    case key
    of "v", "version":
      version()
      break
    of "h", "help":
      usage()
      break
  of cmdEnd:
    discard
