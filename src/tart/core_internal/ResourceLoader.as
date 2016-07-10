package tart.core_internal {

    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Deferred;
    import dessert_knife.tools.async.Promise;

    public class ResourceLoader {

        private var _urlLoader:URLLoader;
        private var _deferred:Deferred;
        private var _url:String;
        private var _isLoading:Boolean = false;

        public function ResourceLoader() {
            _urlLoader = new URLLoader();
            _urlLoader.dataFormat = URLLoaderDataFormat.BINARY;

            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _onIoError);
            _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
            _urlLoader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
            _urlLoader.addEventListener(Event.COMPLETE, _onLoadComplete);
        }

        public function dispose():void {
            _urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _onIoError);
            _urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
            _urlLoader.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
            _urlLoader.removeEventListener(Event.COMPLETE, _onLoadComplete);
        }

        public function load(url:String):Promise {
            if (_isLoading) {
                throw new Error("[Error :: ResourceLoader] Multiple load error.");
            }
            _isLoading = true;

            _url = url;
            var urlRequest:URLRequest = new URLRequest(url);
            _urlLoader.load(urlRequest);

            _deferred = knife.deferred();
            return _deferred.promise;
        }

        private function _onIoError(event:IOErrorEvent):void {
            throw new Error("[Error :: ResourceLoader] IO Error: " + event.text);
        }

        private function _onSecurityError(event:SecurityErrorEvent):void {
            throw new Error("[Error :: ResourceLoader] Security Error: " + event.text);
        }

        private function _onLoadProgress(event:ProgressEvent):void {
            // todo
        }

        private function _onLoadComplete(event:Event):void {
            var bytes:ByteArray = _urlLoader.data as ByteArray;
            TART::LOG_INFO {
                trace("[Info :: ResourceLoader] Load bytes:", _url, "-", bytes.length);
            }
            _finalizeLoad().done(bytes);
        }

        private function _finalizeLoad():Deferred {
            var deferred:Deferred = _deferred;
            _deferred  = null;
            _isLoading = false;
            return deferred;
        }

    }
}
