import client, httpclient, json, parseopt, uri

var localId: string

for kind, key, value in getOpt():
  case kind
  of cmdLongOption, cmdShortOption:
    case key
    of "l", "localid":
      localId = value
    else:
      discard
  of cmdArgument:
    localId = key
  of cmdEnd:
    discard

proc clear*(client: HttpClient, base: Uri) =

  if localId == "":
    quit("Local ID not specified.")

  echo(localId)

  let endpoint = base / "message/clear"

  let jsonPayload = %*{
    "localId": %localId
  }

  let response = client.request(
    $endpoint,
    httpMethod = HttpPost,
    body = $jsonPayload
  )

  let statusCode = code(response)

  quitOnHttpError(statusCode)

  if statusCode != Http204:
    let responseBody = to(parseJson(response.body), NotifierError)
    quit("Failed to clear message. " & responseBody.message)
