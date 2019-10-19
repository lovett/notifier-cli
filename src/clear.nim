import base64, httpclient, json, os, uri

type
  ClearError* = object
    message*: string

proc clear*() =

  if paramCount() < 2:
    quit("Local ID not specified.")

  let localId = paramStr(2)

  var endpoint = parseUri(getEnv("NOTIFIER_URL")) / "message/clear"

  let auth = encode(getEnv("NOTIFIER_USER") & ":" & getEnv("NOTIFIER_PASS"))
  echo(auth)

  let client = newHttpClient()
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "User-Agent": "notifier-cli",
    "Authorization": "Basic " & auth
  })

  let jsonPayload = $(%{
    "localId": %localId
  })

  let response = client.request(
    $endpoint,
    httpMethod = HttpPost,
    body = jsonPayload
  )

  if response.status != "204 No Content":
    let responseBody = to(parseJson(response.body), ClearError)
    quit("Failed to clear message. " & responseBody.message)
