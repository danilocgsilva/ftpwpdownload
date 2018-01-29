
BIN ?= ftpwpdownload
PREFIX ?= /usr/local

install:
	cp ftpwpdownload.sh $(PREFIX)/bin/$(BIN)
	cp wordpress_filelist.list $(PREFIX)/bin/wordpress_filelist
	chmod +x $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	rm -f $(PREFIX)/bin/wordpress_filelist
	