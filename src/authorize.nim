import client, httpclient, json, net, os, parsecfg, terminal, uri

type
  AuthToken* = object
    key*: string
    value*: string

proc authorize*() =
  stdout.write("Notifier Server URL: ")

  var server = parseUri(stdin.readLine())

  if server.hostname == "":
    quit("Invalid URL, cannot continue.")

  server.path = ""

  stdout.write("Username: ")
  let username = stdin.readLine()
  if username == "":
    quit("Username not specified, cannot continue.")

  let password = readPasswordFromSTdin("Password: ")
  if password == "":
    quit("Password not specified, cannot continue.")

  stdout.write("Label (optional): ")
  let label = stdin.readLine()

  let endpoint = server / "auth"

  let jsonPayload = $(%{
    "username": %username,
    "password": %password,
    "persist": %("true"),
    "label": %label
  })

  let client = newHttpClient()
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "User-Agent": AGENT
  })

  try:
    let response = client.request(
      $endpoint,
      httpMethod = HttpPost,
      body = jsonPayload
    )

    let statusCode = code(response)

    quitOnHttpError(statusCode)

    if statusCode != Http200:
      quit("Login failed.")

    let authToken = to(parseJson(response.body), AuthToken)

    let configDir = joinPath(os.getHomeDir(), ".config")

    createDir(configDir)

    var config = newConfig()
    config.setSectionKey("","NOTIFIER_URL", $server)
    config.setSectionKey("","NOTIFIER_USER", authToken.key)
    config.setSectionKey("","NOTIFIER_PASS", authToken.value)
    config.writeConfig(joinPath(configDir, "notifier.ini"))

  except TimeoutError:
    quitOnTimeout()
