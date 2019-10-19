import httpclient, json, terminal, uri

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
    "User-Agent": "notifier-cli"
  })

  let response = client.request(
    $endpoint,
    httpMethod = HttpPost,
    body = jsonPayload
  )

  if response.status != "200 OK":
    quit("Failed to authentication with server.")


  let authToken = to(parseJson(response.body), AuthToken)

  echo("\c\l")
  echo("NOTIFIER_URL=", $server)
  echo("NOTIFIER_USER=", authToken.key)
  echo("NOTIFIER_PASS=", authToken.value)
