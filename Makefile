
LIBNAME = libnotify
OS = Linux
INSTALL_PATH = /usr/lib/neko/

CFLAGS = -shared -Wall -g #-Wall -O3 -fPIC -g -O #-finline-functions
NDLL = ndll/${OS}/${LIBNAME}.ndll
PKG_CONFIG = `pkg-config --cflags --libs gtk+-2.0`
LDFLAGS = -Iinclude -I/usr/lib/neko/include
OBJ = src/hxlibnotify.o

all : ndll

%.o : %.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(PKG_CONFIG) -c -o $@ $<
	
ndll : $(OBJ)
	$(CC) $(CFLAGS) -o $(NDLL) $(OBJ) -l notify
		
tests: tests/* Makefile
	(cd tests; haxe build.hxml)
	
tests-run : tests
	(cd tests; neko $(LIBNAME)_test.n)

doc:
	(cd doc; haxe build.hxml)
	
install: ndll
	cp $(NDLL) $(INSTALL_PATH)
	
clean:
	rm -f $(NDLL)
	rm -f tests/*.n
	rm -f doc/*.xml doc/*.n doc/index.html
	rm -rf doc/content
	
.PHONY: all ndll install tests tests-run doc clean
