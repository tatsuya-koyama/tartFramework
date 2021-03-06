COMMON_BUILD_OPTS=\
	-swf-version=30 \
	-source-path+="../../../src/" \
	-library-path+="../../../lib/" \
	-load-config+="config.xml" \
	-incremental=true

#-----------------------------------------------------------
# build swf for each platforms
#-----------------------------------------------------------

build_debug_web:
	mxmlc \
	$(COMMON_BUILD_OPTS) \
	-debug=true \
	-define+=CONFIG::TART_DEBUG_CONSOLE,true \
	-define+=PLATFORM::WEB,true \
	-output="build/WebMain.swf" \
	./src/Main.as

build_debug_desktop:
	amxmlc \
	$(COMMON_BUILD_OPTS) \
	-debug=true \
	-define+=CONFIG::TART_DEBUG_CONSOLE,true \
	-define+=PLATFORM::DESKTOP,true \
	-output="build/DesktopMain.swf" \
	./src/Main.as

#-----------------------------------------------------------
# run with adl
#-----------------------------------------------------------

run_web:
	adl app-web.xml build/ -screensize 640x960:640x960

run_desktop:
	adl app-desktop.xml build/

#-----------------------------------------------------------
# debug commands
#-----------------------------------------------------------

web:
	make build_debug_web
	make run_web

desk:
	make build_debug_desktop
	make run_desktop

#-----------------------------------------------------------
# release build commands
#-----------------------------------------------------------

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

#-----------------------------------------------------------
# misc.
#-----------------------------------------------------------

clean:
	rm -f build/*.swf
	rm -f build/*.swf.cache
