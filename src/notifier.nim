import os, parseopt
import authorize, clear, client, deauthorize, send, usage, version

proc checkEnv() =
  try:
    doAssert existsEnv("NOTIFIER_URL")
    doAssert existsEnv("NOTIFIER_USER")
    doAssert existsEnv("NOTIFIER_PASS")
  except AssertionError:
    quit("Credentials not found in environment.")

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
