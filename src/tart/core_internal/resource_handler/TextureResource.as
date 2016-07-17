package tart.core_internal.resource_handler {

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.utils.ByteArray;
    import flash.system.ImageDecodingPolicy;
    import flash.system.LoaderContext;

    import starling.textures.Texture;
    import starling.textures.TextureOptions;

    import tart.core.IResourceHandler;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class TextureResource implements IResourceHandler {

        private var _loaderInfo:LoaderInfo;
        private var _textureOptions:TextureOptions;
        private var _defer:Defer;

        public function TextureResource(scaleFactor:Number=1, useMipmaps:Boolean=false) {
            _textureOptions = new TextureOptions(scaleFactor, useMipmaps);
        }

        //----------------------------------------------------------------------
        // implements IResourceHandler
        //----------------------------------------------------------------------

        public function get keyPrefix():String {
            return "tex:";
        }

        public function get resourceType():Class {
            return Texture;
        }

        public function canHandle(extension:String):Boolean {
            return (extension == "png");
        }

        /**
         * Converts byte array to bitmap data and pass it to deferred object.
         */
        public function deserializeAsync(bytes:ByteArray):Defer {
            var loader:Loader = new Loader();
            _loaderInfo = loader.contentLoaderInfo;
            _loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onIoError);
            _loaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete);

            var checkPolicyFile:Boolean = false;
            var loaderContext:LoaderContext = new LoaderContext(checkPolicyFile)
            loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
            loader.loadBytes(bytes, loaderContext);

            _defer = knife.defer();
            return _defer;
        }

        public function dispose(resource:*):void {
            var texture:Texture = resource as Texture;
            texture.dispose();
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _onIoError(event:IOErrorEvent):void {
            throw new Error("[Error :: TextureResource] IO Error: " + event.text);
        }

        private function _onLoadComplete(event:Event):void {
            _loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, _onIoError);
            _loaderInfo.removeEventListener(Event.COMPLETE, _onLoadComplete);

            var bitmap:Bitmap   = event.target.content;
            var texture:Texture = _bitmapToTexture(bitmap);
            _defer.done(texture);
        }

        /**
         * @private
         * ToDo: モバイルではアプリが background にあるときに Stage3D を call すべきでない。
         *       background にあるなら active になるまで処理を遅延する必要がある
         */
        private function _bitmapToTexture(bitmap:Bitmap):Texture {
            var texture:Texture = Texture.fromData(bitmap, _textureOptions)

            // ToDo: lost context 時の texture の restore 処理

            bitmap.bitmapData.dispose();
            return texture;
        }

    }
}
