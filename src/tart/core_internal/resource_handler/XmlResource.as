package tart.core_internal.resource_handler {

    import flash.utils.ByteArray;

    import tart.core.IResourceHandler;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class XmlResource implements IResourceHandler {

        //----------------------------------------------------------------------
        // implements IResourceHandler
        //----------------------------------------------------------------------

        public function get keyPrefix():String {
            return "xml:";
        }

        public function get resourceType():Class {
            return XML;
        }

        public function canHandle(extension:String):Boolean {
            return (extension == "xml");
        }

        public function deserializeAsync(bytes:ByteArray):Defer {
            var xml:XML = XML(bytes);
            return knife.defer().done(xml);
        }

        public function dispose(resource:*):void {
            return;
        }

    }
}
