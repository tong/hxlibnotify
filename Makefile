
OS := $(shell uname)
PROJECT := libnotify
NDLL = ndll/$(OS)/$(PROJECT).ndll
INSTALL_PATH = /usr/lib/neko
OBJS = src/hxlibnotify.o

all: build

%.o: %.c
	$(CC) -O3 -Iinclude -I/usr/lib/neko/include $(shell pkg-config --cflags gtk+-2.0 libnotify) -c -o $@ $<

$(NDLL): $(OBJS)
	$(CC) -shared -o $(NDLL) $(OBJS) $(shell pkg-config --libs libnotify)
	
build: $(NDLL)


install: build
	cp $(NDLL) $(INSTALL_PATH)

update: clean build

doc:
	(cd doc; haxe build.hxml)
	
clean:
	rm -f src/*.o $(NDLL)
	rm -f doc/*.xml doc/*.n doc/index.html && rm -rf doc/content
	
.PHONY: all build install doc clean
