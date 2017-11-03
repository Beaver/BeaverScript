DESTDIR := /usr/local

build:
	@swift build --configuration release

clean:
	rm -rf .build

install: build
	install -d "$(DESTDIR)/bin"
	install -d "$(DESTDIR)/share/beaver"
	install -C -m 755 ".build/release/BeaverScript" "$(DESTDIR)/bin/beaver"

uninstall:
	rm "$(DESTDIR)/bin/beaver"
	rm -rf "$(DESTDIR)/share/beaver"