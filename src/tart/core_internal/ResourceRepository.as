package tart.core_internal {

    import flash.utils.Dictionary;

    import dessert_knife.knife;

    public class ResourceRepository {

        private var _keyToUrl:Dictionary;        // ex. {"tex:filename" : "path/to/filename.png"}
        private var _urlToRefCounts:Dictionary;  // ex. {"path/to/filename.png" : 3}
        private var _urlToResource:Dictionary;   // ex. {"path/to/filename.png" : <Texture>}

        public function ResourceRepository() {
            _keyToUrl       = new Dictionary();
            _urlToRefCounts = new Dictionary();
            _urlToResource  = new Dictionary();
        }

        /**
         * Increments reference count of resource url.
         * @return Reference count after load.
         */
        public function loadUrl(url:String):int {
            if (!_urlToRefCounts[url]) {
                _urlToRefCounts[url] = 0;
            }
            _urlToRefCounts[url] += 1;
            return _urlToRefCounts[url];
        }

        /**
         * Decrements reference count of resource url.
         * @return Reference count after release.
         */
        public function releaseUrl(url:String):int {
            if (!_urlToRefCounts[url]) {
                return 0;
            }
            _urlToRefCounts[url] -= 1;

            if (_urlToRefCounts[url] == 0) {
                delete _urlToRefCounts[url];
                return 0;
            }
            return _urlToRefCounts[url];
        }

        public function store(resource:*, url:String, key:String):void {
            TART::LOG_WARN {
                if (_urlToResource[url]) {
                    trace("[Warn :: ResourceRepository] Resource already stored :", url, "-", resource);
                }
            }

            _urlToResource[url] = resource;
            _keyToUrl[key]      = url;
        }

        public function removeByKey(key:String):* {
            var url:String = _keyToUrl[key];
            if (!url) {
                TART::LOG_ERROR {
                    trace("[Error :: ResourceRepository] Key not found :", key);
                }
                return null;
            }

            var removedResource:* = _urlToResource[url];
            delete _urlToResource[url];
            delete _keyToUrl[key];
            return removedResource;
        }

        public function getByKey(key:String):* {
            var url:String = _keyToUrl[key];
            if (!url) {
                TART::LOG_ERROR {
                    trace("[Error :: ResourceRepository] Key not found :", key);
                }
                return null;
            }
            return _urlToResource[url];
        }

        //----------------------------------------------------------------------
        // debug commands
        //----------------------------------------------------------------------

        public function debug_dumpRefCounts():void {
            trace("[Debug :: ResourceRepository] ***** {URL : Reference Count} map *****");
            trace(knife.str.stringifyDictionary(_urlToRefCounts));
        }

    }
}
