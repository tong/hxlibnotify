
#
# hxlibnotify
#
# For debug build set: debug=true
#

OS = Linux
NDLL_FLAGS =

uname_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
ifeq (${uname_M},x86_64)
OS := Linux64
NDLL_FLAGS += -DHXCPP_M64
HXCPP_FLAGS += -D HXCPP_M64
else
OS := Linux
endif
NDLL = ndll/$(OS)/libnotify.ndll
HX_TEST = haxe -main TestLibnotify -cp ../ $(HXCPP_FLAGS)

ifeq (${debug},true)
HX_TEST += -debug
else
HX_TEST += --no-traces -dce full
endif

all: ndll test

$(NDLL): src/*.cpp
	(cd src;haxelib run hxcpp build.xml $(NDLL_FLAGS);)

ndll: $(NDLL)
	cp $(NDLL) test/

test: $(NDLL) test/TestLibnotify.hx
	@(cd test;$(HX_TEST) -neko libnotify-test.n)
	@(cd test;$(HX_TEST) -cpp bin)
	mv test/bin/TestLibnotify test/libnotify-test
	cp $(NDLL) test/

doc: sys/*.hx
	haxe -neko libinotify.n sys.Notify sys.Notification --no-output -xml libnotify-api.xml #TODO use macro to add doc classes
	mkdir -p doc
	cd doc && haxedoc ../libnotify-api.xml -f sys

clean:
	rm -rf ndll/
	rm -rf src/obj
	rm -f src/all_objs
	rm -rf test/bin
	rm -f test/libnotify*
	rm -rf doc

.PHONY: ndll test doc clean
