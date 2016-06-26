package tart.core {

    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import starling.display.Image;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    import tart.core_internal.ResourceMultiLoader;
    import tart.core_internal.deserializer.BitmapDeserializer;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;
    import dessert_knife.tools.async.Deferred;
    import dessert_knife.tools.async.Promise;

    public class TartResource implements IResourceDeserializer {

        private var _resourceMultiLoader:ResourceMultiLoader;
        private var _loadDeferred:Deferred;
        private var _urlQueue:Array;
        private var _isLoading:Boolean = false;

        public function TartResource() {
            _resourceMultiLoader = new ResourceMultiLoader();
        }

        /**
         * @param urls - Array of URL String.
         */
        public function loadAssetsAsync(urls:Array):void {
            if (_isLoading) {
                throw new Error("[Error :: TartResource] Multiple load error.");
            }
            _isLoading = true;

            _resourceMultiLoader.loadAll(urls, this)
                .then(function():void {
                    _isLoading = false;

                    TART::LOG_DEBUG {
                        trace("[Debug :: TartResource] Load complete.");
                    }
                });
        }

        //----------------------------------------------------------------------
        // implements IResourceDeserializer
        //----------------------------------------------------------------------

        public function deserializeResourceAsync(bytes:ByteArray, url:String):Defer {
            var extension:String = knife.str.extensionOf(url);
            var defer:Defer = knife.defer();

            switch (extension) {
            case "png":
                var deserializer:BitmapDeserializer = new BitmapDeserializer();
                deserializer.deserializeAsync(bytes).then(function(texture:Texture):void {
                    // ToDo: store data
                    trace("--- deserialized:", texture);
                    defer.done();
                });
                break;
            }

            return defer;
        }

        //----------------------------------------------------------------------
        // getters
        //----------------------------------------------------------------------

        public function getImage(name:String):Image {
            return null;
        }

        public function getTexture(name:String):Texture {
            return null;
        }

        public function getTextureAtlas(name:String):TextureAtlas {
            return null;
        }

        public function getSound(name:String):Sound {
            return null;
        }

        public function getObject(name:String):Object {
            return null;
        }

        public function getXml(name:String):XML {
            return null;
        }

        public function getByteArray(name:String):ByteArray {
            return null;
        }

    }
}
