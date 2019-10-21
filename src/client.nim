import base64, httpclient, os, uri

const AGENT* = "notifier-cli"

type
  NotifierError* = object
    message*: string

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

proc quitIfBadAuth* (statusCode: HttpCode) =
  if statusCode == Http401:
    quit("Bad username or password.")

proc quitIfServerError* (statusCode: HttpCode) =
  if is5xx(statusCode):
    quit("Server error.")
