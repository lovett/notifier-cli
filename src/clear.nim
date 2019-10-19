import httpclient, json, os, uri

type
  ClearError = object
    message*: string

proc clear*(client: HttpClient, base: Uri) =

  if paramCount() < 2:
    quit("Local ID not specified.")

  let localId = paramStr(2)

  var endpoint = base / "message/clear"

  let jsonPayload = $(%{
    "localId": %localId
  })

  let response = client.request(
    $endpoint,
    httpMethod = HttpPost,
    body = jsonPayload
  )

  if code(response) != Http204:
    let responseBody = to(parseJson(response.body), ClearError)
    quit("Failed to clear message. " & responseBody.message)
