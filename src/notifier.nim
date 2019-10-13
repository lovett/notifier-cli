import os, parseopt
import authorize, clear, send, usage, version

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
      clear()
      break
    of "help":
      usage()
      break
    of "send":
      send()
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
