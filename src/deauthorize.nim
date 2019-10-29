import base64, client, httpclient, json, net, strutils, uri

proc deauthorize*(client: HttpClient, base: Uri) =

  let endpoint = base / "deauth"

  let encodedAuth = substr(
    client.headers["Authorization"],
    find(client.headers["Authorization"], ' ') + 1
  )

  let authFields = split(decode(encodedAuth), ':', 1)

  let jsonPayload = %*{
    "key": authFields[0],
    "value": authFields[1]
  }

  try:
    let response = client.request(
      $endpoint,
      httpMethod = HttpPost,
      body = $jsonPayload
    )

    if code(response) != Http200:
      let responseBody = to(parseJson(response.body), NotifierError)
      quit("Failed to deauthorize. " & responseBody.message)

    echo("export NOTIFIER_USER=")
    echo("export NOTIFIER_PASS=")

  except TimeoutError:
    quitOnTimeout()
