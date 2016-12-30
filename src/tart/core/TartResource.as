package tart.core {

    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import starling.display.Image;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    import tart.core_internal.ResourceMultiLoader;
    import tart.core_internal.ResourceRepository;
    import tart.core_internal.resource_handler.AwdResource;
    import tart.core_internal.resource_handler.TextureResource;
    import tart.core_internal.resource_handler.XmlResource;
    import tart.core_internal.resource_plugin.TextureAtlasPlugin;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;
    import dessert_knife.tools.async.Deferred;
    import dessert_knife.tools.async.Promise;

    public class TartResource implements IResourceDeserializer {

        private var _handlers:Vector.<IResourceHandler>;
        private var _plugins:Vector.<IResourcePlugin>;
        private var _resourceMultiLoader:ResourceMultiLoader;
        private var _resourceRepo:ResourceRepository;

        private var _loadDeferred:Deferred;
        private var _urlQueue:Array;
        private var _isLoading:Boolean = false;
        private var _resourcesNewlyLoaded:Array;

        public function TartResource() {
            // Todo : enable to customize by boot config
            _handlers = new <IResourceHandler>[
                new TextureResource(),
                new XmlResource(),
                new AwdResource()
            ];
            _plugins = new <IResourcePlugin>[
                new TextureAtlasPlugin()
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

            _resourcesNewlyLoaded = [];
            var urlsNewlyFound:Array = _extractUrlsNewlyFound(urls);

            return _resourceMultiLoader.loadAll(urlsNewlyFound, this)
                .then(function():void {
                    _isLoading = false;
                    _processPlugins_afterLoad(_resourcesNewlyLoaded);

                    TART::LOG_DEBUG {
                        trace("[Debug :: TartResource] Load complete.");
                        _resourceRepo.debug_dumpRefCounts();
                        // _resourceRepo.debug_dumpKeys();
                        // _resourceRepo.debug_dumpResources();
                    }
                });
        }

        /**
         * @param urls - Array of URL String.
         */
        public function releaseAssets(urls:Array):void {
            var urlsNoLongerUsed:Array = _extractUrlsNoLongerUsed(urls);
            _processPlugins_beforeRelease(urlsNoLongerUsed);

            for each (var url:String in urlsNoLongerUsed) {
                TART::LOG_INFO {
                    trace("[Info :: TartResource] (-) Release asset:", url);
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
                _resourcesNewlyLoaded.push(resource);
                defer.done();
            });
            return defer;
        }

        //----------------------------------------------------------------------
        // getters for build-in resource type
        //----------------------------------------------------------------------

        public function getImage(key:String):Image {
            var texture:Texture = getTexture(key);
            if (!texture) { return null; }

            return new Image(texture);
        }

        public function getTexture(key:String):Texture {
            var texture:* = _resourceRepo.getByKey(TextureResource.KEY_PREFIX + key, true);
            if (texture) { return texture as Texture; }

            // find from texture atlas
            texture = _findResourceByPlugins(key);
            if (texture) { return texture as Texture; }

            TART::LOG_ERROR {
                trace("[Error :: TartResource] Texture not found:", key);
            }
            return null;
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
            return _resourceRepo.getByKey(XmlResource.KEY_PREFIX + key);
        }

        public function getByteArray(key:String):ByteArray {
            return null;
        }

        public function getAwd(key:String):ByteArray {
            return _resourceRepo.getByKey(AwdResource.KEY_PREFIX + key);
        }

        //----------------------------------------------------------------------
        // getters for general purpose
        //----------------------------------------------------------------------

        public function getByKey(keyPrefix:String, key:String):* {
            return _resourceRepo.getByKey(keyPrefix + key);
        }

        /**
         * If you cannot retrieve resources generated by user plugins,
         * this is a last resort.
         */
        public function get repository():ResourceRepository {
            return _resourceRepo;
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

        private function _processPlugins_afterLoad(resourcesNewlyLoaded:Array):void {
            for each (var plugin:IResourcePlugin in _plugins) {
                plugin.afterLoad(resourcesNewlyLoaded, this, _resourceRepo);
            }
        }

        private function _processPlugins_beforeRelease(urlsNoLongerUsed:Array):void {
            var keysNoLongerUsed:Vector.<String> = new Vector.<String>();

            for each (var url:String in urlsNoLongerUsed) {
                var extension:String    = knife.str.extensionOf(url);
                var resourceName:String = knife.str.fileNameOf(url);

                var handler:IResourceHandler = _findHandler(extension);
                var resourceKey:String = handler.keyPrefix + resourceName;
                keysNoLongerUsed.push(resourceKey);
            }

            for each (var plugin:IResourcePlugin in _plugins) {
                plugin.beforeRelease(keysNoLongerUsed, this, _resourceRepo);
            }
        }

        private function _findResourceByPlugins(key:String):* {
            for each (var plugin:IResourcePlugin in _plugins) {
                var resource:* = plugin.findResource(key, this, _resourceRepo);
                if (resource) { return resource; }
            }
            return null;
        }

    }
}
