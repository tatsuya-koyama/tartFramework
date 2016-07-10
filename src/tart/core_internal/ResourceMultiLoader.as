package tart.core_internal {

    import flash.utils.ByteArray;

    import tart.core.IResourceDeserializer;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Deferred;
    import dessert_knife.tools.async.Promise;

    /**
     * ResourceMultiLoader loads multiple assets in parallel.
     */
    public class ResourceMultiLoader {

        private var _reservedLoaders:Vector.<ResourceLoader>;
        private var _numActiveLoader:uint;
        private var _deferred:Deferred;
        private var _deserializer:IResourceDeserializer;
        private var _urlQueue:Array;
        private var _isLoading:Boolean = false;

        public function ResourceMultiLoader(loadThrottle:uint=3) {
            _reservedLoaders = new Vector.<ResourceLoader>();
            _numActiveLoader = 0;

            for (var i:int = 0; i < loadThrottle; ++i) {
                _reservedLoaders.push(new ResourceLoader());
            }
        }

        public function loadAll(urls:Array, deserializer:IResourceDeserializer):Promise {
            if (_isLoading) {
                throw new Error("[Error :: ResourceMultiLoader] Multiple load error.");
            }
            if (!urls || urls.length == 0) {
                return knife.deferred().done().promise;
            }

            _isLoading    = true;
            _urlQueue     = knife.list.clone(urls);
            _deserializer = deserializer;
            _loadNext(_urlQueue);

            _deferred = knife.deferred();
            return _deferred.promise;
        }

        private function _loadNext(urlQueue:Array):void {
            if (_reservedLoaders.length == 0) { return; }

            var url:String = urlQueue.shift();
            var loader:ResourceLoader = _reservedLoaders.pop();
            _numActiveLoader += 1;

            loader.load(url).then(
                _onLoadHandler(loader, url, urlQueue)
            );

            if (urlQueue.length > 0) {
                _loadNext(urlQueue);
            }
        }

        private function _onLoadHandler(loader:ResourceLoader,
                                        url:String, urlQueue:Array):Function
        {
            return function(bytes:ByteArray):void {
                _deserializer.deserializeResourceAsync(bytes, url).then(function():void {
                    _reservedLoaders.push(loader);
                    _numActiveLoader -= 1;

                    if (urlQueue.length > 0) {
                        _loadNext(urlQueue);
                    }
                    else if (_numActiveLoader == 0) {
                        _finalizeLoad().done();
                    }
                });
            };
        }

        private function _finalizeLoad():Deferred {
            var deferred:Deferred = _deferred;
            _deferred        = null;
            _urlQueue        = null;
            _deserializer    = null;
            _isLoading       = false;
            _numActiveLoader = 0;
            return deferred;
        }

    }
}
