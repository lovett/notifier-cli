import client, httpclient, json, terminal, uri

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
    "label": %label
  })

  let client = newHttpClient()
  client.headers = newHttpHeaders({
    "Content-Type": "application/json",
    "User-Agent": AGENT
  })

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

  echo("\c\l")
  echo("NOTIFIER_URL=", $server)
  echo("NOTIFIER_USER=", authToken.key)
  echo("NOTIFIER_PASS=", authToken.value)
