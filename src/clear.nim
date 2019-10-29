import client, httpclient, json, net, parseopt, uri

var localId: string
var verbose = false

for kind, key, value in getOpt():
  case kind
  of cmdLongOption, cmdShortOption:
    case key
    of "l", "localid":
      localId = value
    of "v", "verbose":
      verbose = true
    else:
      discard
  of cmdArgument:
    localId = key
  of cmdEnd:
    discard


proc clear*(client: HttpClient, base: Uri) =
  if localId == "":
    quit("Local ID not specified.")

  let endpoint = base / "message/clear"

  if verbose:
    echo("Posting to " & $endpoint)

  let jsonPayload = %*{
    "localId": %localId
  }

  echo("JSON: " & $jsonPayload)

  try:
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

  except TimeoutError:
    quitOnTimeout()
