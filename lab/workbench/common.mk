COMMON_BUILD_OPTS=\
	-swf-version=35 \
	-source-path+="../../../src/" \
	-source-path+="../../lab_lib/" \
	-library-path+="../../../lib/" \
	-load-config+="config.xml"

#----------------------------------------------------------
# build swf for each platforms
#----------------------------------------------------------

# @private
assets_dir:
	mkdir -p ./build
	ln -sf ../../../lab_assets ./build/

# @private
build_debug_web:
	mxmlc \
	$(COMMON_BUILD_OPTS) \
	-debug=true \
	-define+=CONFIG::TART_DEBUG_CONSOLE,true \
	-define+=PLATFORM::WEB,true \
	-output="build/WebMain.swf" \
	./src/Main.as

# @private
build_debug_desktop:
	amxmlc \
	$(COMMON_BUILD_OPTS) \
	-debug=true \
	-define+=CONFIG::TART_DEBUG_CONSOLE,true \
	-define+=PLATFORM::DESKTOP,true \
	-output="build/DesktopMain.swf" \
	./src/Main.as

#----------------------------------------------------------
# run with adl
#----------------------------------------------------------

# @private
run_web:
	adl app-web.xml build/ -screensize 800x1200:800x1200 \
	    2>&1 | ../../../tools/scripts/colorline \
	    "Error" "\[Warn" "\[Info" "\[Debug" "\-\->|<\-\-|\*\*\*|///"

# @private
run_desktop:
	adl app-desktop.xml build/

##----------------------------------------------------------
## debug commands
##----------------------------------------------------------

web:
	make assets_dir
	make build_debug_web
	make run_web

desk:
	make assets_dir
	make build_debug_desktop
	make run_desktop

##----------------------------------------------------------
## release build commands
##----------------------------------------------------------

cert:
ifdef pass
	adt -certificate -validityPeriod 25 -cn SelfSigned 2048-RSA build/sampleCert.p12 $(pass)
else
	@echo "Usage: make cert pass=your_cert_password"
endif

rel_mac:
ifdef pass
	make build_debug_desktop
	cd build/; \
	adt -package \
	    -storetype pkcs12 \
	    -keystore sampleCert.p12 \
	    -storepass $(pass) \
	    -target bundle \
	    sampleApp.app \
	    ../app-desktop.xml \
	    DesktopMain.swf
else
	@echo "Usage: make rel_mac pass=your_cert_password"
endif

##----------------------------------------------------------
## misc.
##----------------------------------------------------------

help:
	@../../../tools/scripts/makedocs ../common.mk

clean:
	rm -f build/*.swf
	rm -f build/*.swf.cache
