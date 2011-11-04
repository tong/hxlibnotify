
LIBNAME = libnotify
OS = Linux
INSTALL_PATH = /usr/lib/neko/

CFLAGS = -g -O2 -Wall #-Wimplicit-function-declaration #-finline-functions
NDLL = ndll/${OS}/${LIBNAME}.ndll
LIBNOTIFY_FLAGS = $(shell pkg-config --cflags --libs libnotify)
#GTK_LIBS = -lfontconfig -lcairo -lpango-1.0 -lfreetype
#GTK_FLAGS = -I/usr/include/gtk-2.0 -I/usr/lib/i386-linux-gnu/gtk-2.0/include -I/usr/include/atk-1.0 -I/usr/include/cairo -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/pango-1.0 -I/usr/include/gio-unix-2.0/ -I/usr/include/glib-2.0 -I/usr/lib/i386-linux-gnu/glib-2.0/include -I/usr/include/pixman-1 -I/usr/include/freetype2 -I/usr/include/libpng12
GTK_FLAGS = $(shell pkg-config --cflags --libs gtk+-2.0)
LDFLAGS = -Iinclude -I/usr/lib/neko/include
OBJ = src/hxlibnotify.o

all : ndll

%.o : %.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(GTK_FLAGS) $(LIBNOTIFY_FLAGS) -c -o $@ $<
	
ndll : $(OBJ)
	$(CC) -shared $(CFLAGS) -o $(NDLL) $(OBJ) -lnotify
		
tests:
	(cd tests; haxe build.hxml)
	
tests-run : tests
	(cd tests; neko $(LIBNAME)_test.n)

doc:
	(cd doc; haxe build.hxml)
	
install: ndll
	cp $(NDLL) $(INSTALL_PATH)
	
clean:
	rm -f src/*.o
	rm -f $(NDLL)
	rm -f tests/*.n
	rm -f doc/*.xml doc/*.n doc/index.html
	rm -rf doc/content
	
.PHONY: all ndll install tests tests-run doc clean
