package tart.core_internal.resource_handler {

    import flash.utils.ByteArray;

    import away3d.events.LoaderEvent;
    import away3d.loaders.Loader3D;
    import away3d.loaders.misc.AssetLoaderContext;
    import away3d.loaders.parsers.Max3DSParser;

    import tart.core.IResourceHandler;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Max3dsResource implements IResourceHandler {

        public static const KEY_PREFIX:String = "3ds:";

        private var _loaderContext:AssetLoaderContext;

        public function Max3dsResource(dependencyBaseUrl:String="") {
            _loaderContext = new AssetLoaderContext(true, dependencyBaseUrl);
        }

        //----------------------------------------------------------------------
        // implements IResourceHandler
        //----------------------------------------------------------------------

        public function get keyPrefix():String {
            return KEY_PREFIX;
        }

        public function get resourceType():Class {
            return Max3dsResource;
        }

        public function canHandle(extension:String):Boolean {
            return (extension == "3ds");
        }

        public function deserializeAsync(bytes:ByteArray):Defer {
            var defer:Defer = knife.defer();
            var loader3d:Loader3D = new Loader3D(false, null);
            loader3d.loadData(bytes, _loaderContext, null, new Max3DSParser());

            var listener:Function = function(event:LoaderEvent):void {
                loader3d.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, listener);
                defer.done(loader3d);
            };
            loader3d.addEventListener(LoaderEvent.RESOURCE_COMPLETE, listener);
            return defer;
        }

        public function dispose(resource:*):void {
            return;
        }

    }
}
