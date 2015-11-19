asdoc:
	asdoc -doc-sources  src/ \
	      -library-path lib/ \
	      -main-title   "tartFramework" \
	      -window-title "tartFramework" \
	      -output ./asdoc-output
