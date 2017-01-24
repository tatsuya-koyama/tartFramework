package tart.core_internal.resource_handler {

    import flash.utils.ByteArray;

    import away3d.events.LoaderEvent;
    import away3d.loaders.Loader3D;
    import away3d.loaders.misc.AssetLoaderContext;
    import away3d.loaders.parsers.AWDParser;

    import tart.core.IResourceHandler;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class AwdResource implements IResourceHandler {

        public static const KEY_PREFIX:String = "awd:";

        private var _loaderContext:AssetLoaderContext;

        public function AwdResource(dependencyBaseUrl:String="") {
            _loaderContext = new AssetLoaderContext(true, dependencyBaseUrl);
        }

        //----------------------------------------------------------------------
        // implements IResourceHandler
        //----------------------------------------------------------------------

        public function get keyPrefix():String {
            return KEY_PREFIX;
        }

        public function get resourceType():Class {
            return AwdResource;
        }

        public function canHandle(extension:String):Boolean {
            return (extension == "awd");
        }

        public function deserializeAsync(bytes:ByteArray):Defer {
            var defer:Defer = knife.defer();
            var loader3d:Loader3D = new Loader3D(false, null);
            loader3d.loadData(bytes, _loaderContext, null, new AWDParser());

            var listener:Function = function(event:LoaderEvent):void {
                loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, listener);
                defer.done(loader3d);
            };
            loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, listener);
            return defer;
        }

        public function dispose(resource:*):void {
            var loader3d:Loader3D = Loader3D(resource);
            loader3d.dispose();
        }

    }
}
