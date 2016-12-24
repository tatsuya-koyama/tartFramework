asdoc:
	asdoc -doc-sources  src/ \
	      -library-path lib/ \
	      -load-config+="asdoc-config.xml" \
	      -main-title   "tartFramework" \
	      -window-title "tartFramework" \
	      -strict=false \
	      -output ./asdoc-output \
	2>&1 | tools/scripts/colorline error: warning:
