asdoc:
	asdoc -doc-sources  src/ \
	      -library-path lib/ \
	      -load-config+="asdoc-config.xml" \
	      -main-title   "tartFramework" \
	      -window-title "tartFramework" \
	      -output ./asdoc-output
