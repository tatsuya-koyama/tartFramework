package tart.core {

    import flash.utils.ByteArray;

    import dessert_knife.tools.async.Defer;

    public interface IResourceHandler {

        function get keyPrefix():String;

        function get resourceType():Class;

        function canHandle(extension:String):Boolean;

        function deserializeAsync(bytes:ByteArray):Defer;

        function dispose(resource:*):void;

    }
}
