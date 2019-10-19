import httpclient, parseopt, uri

var badge: string
var body: string
var expiration: string
var group: string
var localid: string
var title: string
var url: string

for kind, key, value in getOpt():
  case kind
  of cmdLongOption, cmdShortOption:
    case key
    of "b", "body":
      body = value
    of "e", "expire":
       expiration = value
    of "i", "badge":
      badge = value
    of "g", "group":
      group = value
    of "l", "localid":
      localid = value
    of "t", "title":
      title = value
    of "u", "url":
      url = value
  else:
    discard


proc send*(client: HttpClient, base: Uri) =
  echo("Placeholder for send command")
  echo(title)
