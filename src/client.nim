import base64, httpclient, os, uri

const AGENT* = "notifier-cli"

proc makeClient*: (HttpClient, Uri) =
  let auth = encode(getEnv("NOTIFIER_USER") & ":" & getEnv("NOTIFIER_PASS"))

  let client = newHttpClient()

  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Accept": "application/json",
    "User-Agent": "notifier-cli",
    "Authorization": "Basic " & auth
  })

  result = (client, parseUri(getEnv("NOTIFIER_URL")))
