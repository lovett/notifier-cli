import base64, httpclient, os, parsecfg, uri

const AGENT* = "notifier-cli"

type
  NotifierError* = object
    message*: string

proc makeClient*: (HttpClient, Uri) =
  let configFile = joinPath(os.getHomeDir(), ".config", "notifier.ini")

  if not fileExists(configFile):
    quit("Credentials not found.")

  let config = loadConfig(configFile)

  let auth = encode(
    config.getSectionValue("", "NOTIFIER_USER") & ":" &
    config.getSectionValue("", "NOTIFIER_PASS")
  )

  let client = newHttpClient(timeout=3000)

  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "Accept": "application/json",
    "User-Agent": "notifier-cli",
    "Authorization": "Basic " & auth
  })

  result = (client, parseUri(config.getSectionValue("", "NOTIFIER_URL")))

proc quitOnHttpError* (statusCode: HttpCode) =
  if statusCode == Http401:
    quit("Bad username or password.")

  if is5xx(statusCode):
    quit("Server error.")

  if is4xx(statusCode):
    quit("Server returned " & $statusCode)

proc quitOnTimeout* () =
  quit("Timeout while trying to contact the server.")
