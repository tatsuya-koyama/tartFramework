# Using AIR SDK 19
SWF_VERSION=30

test:
	make build_test
	make run_test

build_test:
	mxmlc -incremental=true \
	      -library-path+="lib/" \
	      -library-path+="../lib/" \
	      -source-path+="../src/" \
	      -load-config+="src/config.xml" \
	      -swf-version=$(SWF_VERSION) \
	      -output="build/TestRunner.swf" \
	      -debug=true \
	      src/TestRunner.as

run_test:
	adl src/TestRunner-app.xml build/ -screensize 1360x738:1360x738 \
	    2>&1 | ../tools/scripts/colorline error OK but: failures!

clean:
	rm -f build/*

