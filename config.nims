import os
from strformat import fmt

const exeName = "notifier"
const entrypoint = "src/notifier"

task build, "Build the executable for local use":
  let destination = projectDir()
  exec fmt"nim -d:ssl -d:release --outdir:{destination} --opt:size c {entrypoint}"

task install, "Copy the executable to ~/.local/bin":
  let source = projectDir() / exeName
  let destination = expandTilde("~/.local/bin" / exeName)
  mkDir parentDir(destination)
  cpFile source, destination
  exec fmt"chmod 0755 {destination}"

task installArm, "Compile and install the executable on a remote ARM host":
  if system.paramCount() < 2:
    quit("Remost host not specified")

  let remoteHost = system.paramStr(2)

  exec fmt"nim c -d:ssl -d:release --cpu:arm --os:linux --compileOnly --genScript {entrypoint}"
  exec fmt"nim remoteCompile {exeName} {remoteHost}"
  exec fmt"nim remoteInstall {exeName} {remoteHost}"

task mirror, "Push the repository to GitHub":
    exec "git push --force git@github.com:lovett/notifier-cli.git master:master"

task remoteCompile, "":
  if system.paramCount() < 3:
    quit("Remote compile hostname not specified.")

  let remoteHost = system.paramStr(3)

  switch("define", "release")
  let cachePath = nimCacheDir()

  # This is a workaround for a problem with Nim v1.4 where remote compilation fails
  # because nimbase.h is not available the way it was in Nim v1.0.x.
  #
  # The workaround consits of patching the compile script so that it
  # references an rsyncd copy of the Nim lib directory rather than the
  # equivalent path on the current host.
  #
  # See https://github.com/nim-lang/Nim/issues/13826
  exec fmt"sed -i 's|/usr/local/src/nim-1.4.2/lib|/tmp/nim|' {cachePath}/compile_{exeName}.sh"
  exec fmt"rsync -az --delete {cachePath}/ {remoteHost}:/tmp/{exeName}"
  exec fmt"rsync -az --delete /usr/local/src/nim-1.4.2/lib/ {remoteHost}:/tmp/nim"
  exec fmt"ssh {remoteHost} 'cd /tmp/{exeName} && /bin/sh compile_{exeName}.sh'"

task remoteInstall, "":
  if system.paramCount() < 3:
    quit("Remote install hostname not specified.")

  let remoteHost = system.paramStr(3)

  exec fmt"ssh {remoteHost} 'sudo cp /tmp/{exeName}/{exeName} /usr/local/bin/{exeName}'"
  exec fmt"ssh {remoteHost} 'rm -rf /tmp/{exeName}'"
