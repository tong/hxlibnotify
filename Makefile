
LIBNAME = libnotify
OS = Linux
INSTALL_PATH = /usr/lib/neko/

CFLAGS = -shared -g -O2 -Wall #-finline-functions
NDLL = ndll/${OS}/${LIBNAME}.ndll
LIBNOTIFY_FLAGS = $(shell pkg-config --cflags --libs gtk+-2.0) -l notify
LDFLAGS = -Iinclude -I/usr/lib/neko/include
OBJ = src/hxlibnotify.o

all : ndll

%.o : %.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBNOTIFY_FLAGS) -c -o $@ $<
	
ndll : $(OBJ)
	$(CC) $(CFLAGS) -o $(NDLL) $(OBJ) $(LDFLAGS) $(LIBNOTIFY_FLAGS)
		
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
