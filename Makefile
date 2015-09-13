
## hxlibnotify

PROJECT=libnotify
OS=$(shell sh -c 'uname -s 2>/dev/null || echo not')
ARCH=$(shell sh -c 'uname -m 2>/dev/null || echo not')
NDLL_FLAGS=

ifeq (${ARCH},x86_64)
OS:=Linux64
NDLL_FLAGS+=-DHXCPP_M64
HXCPP_FLAGS+=-D HXCPP_M64
endif

SRC=src/sys/ui/*.hx
NDLL=ndll/$(OS)/$(PROJECT).ndll
HX_TEST=haxe -main TestLibnotify -cp ../ $(HXCPP_FLAGS)

ifeq (${debug},true)
HX_TEST+=-debug
else
HX_TEST+=--no-traces -dce full
endif

all: ndll

$(NDLL): project/*.cpp project/build.xml
	(cd project;haxelib run hxcpp build.xml $(NDLL_FLAGS);)

ndll: $(NDLL)

#example: $(NDLL) example/*.hx
	#@(cd example;$(HX_TEST) -neko hxlibnotify.n)
	#@(cd example;$(HX_TEST) -cpp bin)
	#mv test/bin/TestLibnotify-debug test/libnotify-test

haxedoc.xml: $(SRC)
	#haxe --no-output -neko api.n sys.ui.Notify sys.ui.Notification -xml libnotify-neko.xml
	#haxe --no-output -cpp api sys.ui.Notify sys.ui.Notification -xml libnotify-cpp.xml
	haxe sys.ui.Notify sys.ui.Notification -xml $@ -cp src

#documentation: $(SRC)
	#@mkdir -p doc
	#@haxe sys.ui.Notify sys.ui.Notification -xml haxedoc.xml --no-output -neko api.n
	#@(cd doc;haxelib run dox -i ../ -o ./;)

hxlibnotify.zip: clean ndll haxedoc.xml
	zip -r $@ ndll/ src/ haxedoc.xml haxelib.json README.md

haxelib: hxlibnotify.zip

install: haxelib
	haxelib local hxlibnotify.zip

uninstall:
	haxelib remove libnotify

clean:
	rm -f $(NDLL)
	rm -rf project/obj
	rm -f project/all_objs
	rm -rf example/cpp
	rm -f example/TestLibnotify
	rm -f example/*.n

.PHONY: all ndll clean
