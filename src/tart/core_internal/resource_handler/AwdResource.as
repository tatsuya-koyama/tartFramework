package tart.core_internal.resource_handler {

    import flash.utils.ByteArray;

    import tart.core.IResourceHandler;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class AwdResource implements IResourceHandler {

        public static const KEY_PREFIX:String = "awd:";

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
            return knife.defer().done(bytes);
        }

        public function dispose(resource:*):void {
            return;
        }

    }
}
