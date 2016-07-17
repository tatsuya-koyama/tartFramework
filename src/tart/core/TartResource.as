package tart.core {

    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import starling.display.Image;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    import tart.core_internal.ResourceMultiLoader;
    import tart.core_internal.ResourceRepository;
    import tart.core_internal.resource_handler.TextureResource;
    import tart.core_internal.resource_handler.XmlResource;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;
    import dessert_knife.tools.async.Deferred;
    import dessert_knife.tools.async.Promise;

    public class TartResource implements IResourceDeserializer {

        private var _handlers:Vector.<IResourceHandler>;
        private var _resourceMultiLoader:ResourceMultiLoader;
        private var _loadDeferred:Deferred;
        private var _urlQueue:Array;
        private var _isLoading:Boolean = false;
        private var _resourceRepo:ResourceRepository;

        public function TartResource() {
            // Todo : enable to customize by boot config
            _handlers = new <IResourceHandler>[
                new TextureResource(),
                new XmlResource()
            ];

            _resourceMultiLoader = new ResourceMultiLoader();
            _resourceRepo        = new ResourceRepository();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        /**
         * @param urls - Array of URL String.
         */
        public function loadAssetsAsync(urls:Array):Promise {
            if (_isLoading) {
                throw new Error("[Error :: TartResource] Multiple load error.");
            }
            _isLoading = true;

            var urlsNewlyFound:Array = _extractUrlsNewlyFound(urls);

            return _resourceMultiLoader.loadAll(urlsNewlyFound, this)
                .then(function():void {
                    _isLoading = false;

                    TART::LOG_DEBUG {
                        trace("[Debug :: TartResource] Load complete.");
                        _resourceRepo.debug_dumpRefCounts();
                    }
                });
        }

        /**
         * @param urls - Array of URL String.
         */
        public function releaseAssets(urls:Array):void {
            var urlsNoLongerUsed:Array = _extractUrlsNoLongerUsed(urls);

            for each (var url:String in urlsNoLongerUsed) {
                TART::LOG_INFO {
                    trace("[Info :: TartResource] --- Release asset:", url);
                }
                var extension:String    = knife.str.extensionOf(url);
                var resourceName:String = knife.str.fileNameOf(url);

                var handler:IResourceHandler = _findHandler(extension);
                var resource:* = _resourceRepo.removeByKey(handler.keyPrefix + resourceName);
                handler.dispose(resource);
            }

            TART::LOG_DEBUG {
                trace("[Debug :: TartResource] Release complete.");
                _resourceRepo.debug_dumpRefCounts();
            }
        }

        //----------------------------------------------------------------------
        // implements IResourceDeserializer
        //----------------------------------------------------------------------

        public function deserializeResourceAsync(bytes:ByteArray, url:String):Defer {
            var extension:String    = knife.str.extensionOf(url);
            var resourceName:String = knife.str.fileNameOf(url);
            var defer:Defer = knife.defer();

            var handler:IResourceHandler = _findHandler(extension);
            handler.deserializeAsync(bytes).then(function(resource:*):void {
                _resourceRepo.store(resource, url, handler.keyPrefix + resourceName);
                defer.done();
            });
            return defer;
        }

        //----------------------------------------------------------------------
        // getters
        //----------------------------------------------------------------------

        public function getImage(key:String):Image {
            var texture:Texture = getTexture(key);
            if (!texture) {
                TART::LOG_ERROR {
                    trace("[Error :: TartResource] Image not found:", key);
                }
                return null;
            }
            return new Image(texture);
        }

        public function getTexture(key:String):Texture {
            return _resourceRepo.getByKey("tex:" + key);
        }

        public function getTextureAtlas(key:String):TextureAtlas {
            return null;
        }

        public function getSound(key:String):Sound {
            return null;
        }

        public function getObject(key:String):Object {
            return null;
        }

        public function getXml(key:String):XML {
            return _resourceRepo.getByKey("xml:" + key);
        }

        public function getByteArray(key:String):ByteArray {
            return null;
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _findHandler(extension:String):IResourceHandler {
            for each (var handler:IResourceHandler in _handlers) {
                if (handler.canHandle(extension)) {
                    return handler;
                }
            }
            throw new Error("[Error :: TartResource] Cannot handle aseet type: " + extension);
            return null;
        }

        private function _extractUrlsNewlyFound(urls:Array):Array {
            return urls.filter(function(url:String, index:int, array:Array):Boolean {
                return (_resourceRepo.loadUrl(url) == 1);
            });
        }

        private function _extractUrlsNoLongerUsed(urls:Array):Array {
            return urls.filter(function(url:String, index:int, array:Array):Boolean {
                return (_resourceRepo.releaseUrl(url) == 0);
            });
        }

    }
}
