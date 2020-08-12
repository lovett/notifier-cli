build:
	nim c -d:release -o:./notifier src/notifier

debug:
	nim c src/notifier

# Push the repository to GitHub.
mirror:
	git push --force git@github.com:lovett/notifier-cli.git master:master
