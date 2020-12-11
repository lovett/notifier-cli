from strformat import fmt

const entrypoint = "src/notifier"

task build, "Build the executable for local use":
  let destination = projectDir()
  exec fmt"nim -d:ssl -d:release --outdir:{destination} --opt:size c {entrypoint}"

task mirror, "Push the repository to GitHub":
    exec "git push --force git@github.com:lovett/notifier-cli.git master:master"
