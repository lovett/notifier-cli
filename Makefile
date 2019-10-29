build:
	nim c -d:release -o:./notifier src/notifier

debug:
	nim c src/notifier
