import client, httpclient, json, parseopt, tables, uri

var message = initTable[string, string]()
message["title"] = "Untitled"
message["deliveryStyle"] = "normal"

var verbose = false

for kind, key, value in getOpt():
  case kind
  of cmdLongOption, cmdShortOption:
    case key
    of "b", "body":
      message["body"] = value
    of "d", "deliverystyle":
      message["deliveryStyle"] = value
    of "e", "expire":
      message["expiresAt"] = value
    of "i", "badge":
      message["badge"] = value
    of "g", "group":
      message["group"] = value
    of "l", "localid":
      message["localId"] = value
    of "t", "title":
      message["title"] = value
    of "u", "url":
      message["url"] = value
    of "v", "verbose":
      verbose = true
    else:
      discard
  of cmdArgument, cmdEnd:
    discard


proc send*(client: HttpClient, base: Uri) =
  let endpoint = base / "message"

  if verbose:
    echo("Posting to " & $endpoint)

  let jsonPayload = %*message

  echo("JSON: " & $jsonPayload)

  let response = client.request(
    $endpoint,
    httpMethod = HttpPost,
    body = $jsonPayload
  )

  let statusCode = code(response)

  quitOnHttpError(statusCode)

  if code(response) != Http204:
    let responseBody = to(parseJson(response.body), NotifierError)
    quit(responseBody.message)

proc whisper*(client: HttpClient, base: Uri) =
  message["deliveryStyle"] = "whisper"
  send(client, base)
