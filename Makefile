
OS = Linux
ifeq (${WIN32},1)
OS = Windows
endif
ifeq (${MACOSX},1)
OS = Mac
endif

INSTALL_PATH = /usr/lib/neko/
CFLAGS = -Wall -O3 -fPIC -g -O #-finline-functions
NDLL = ndll/$(OS)/libnotify.ndll
PKG = `pkg-config --cflags --libs glib-2.0 --libs gtk+-2.0`
LIBS = -Iinclude -I/usr/include -I/usr/lib/neko/include -I/usr/include/glib-2.0 -I/usr/include/gtk-2.0 -I/usr/include/libnotify
SRC = src/hxlibnotify.c

all: ndll

ndll : $(SRC) Makefile
	${CC} -shared ${CFLAGS} -o ${NDLL} ${SRC} -l notify ${LIBS} ${PKG}

hxcpp:
	haxelib run hxcpp hxcpp.xml

install: ndll
	cp $(NDLL) /usr/lib/neko/
	
clean:
	rm -f $(NDLL)
	
.PHONY: ndll hxcpp install clean
