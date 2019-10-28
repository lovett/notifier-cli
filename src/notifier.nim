import os, parseopt
import authorize, clear, client, deauthorize, send, usage, version

proc checkEnv() =
  for key in @["NOTIFIER_URL", "NOTIFIER_USER", "NOTIFIER_PASS"]:
    if not existsEnv(key):
      quit(key & " environment variable is not set")

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
      checkEnv()
      let (client, base) = makeClient()
      clear(client, base)
      break
    of "deauth", "deauthorize":
      checkEnv()
      let (client, base) = makeClient()
      deauthorize(client, base)
      break
    of "help":
      usage()
      break
    of "send":
      checkEnv()
      let (client, base) = makeClient()
      send(client, base)
      break
    of "version":
      version()
      break
    of "whisper":
      checkEnv()
      let (client, base) = makeClient()
      whisper(client, base)
    else:
      echo("Invalid command")
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
