package tart.core {

    import flash.utils.ByteArray;

    import dessert_knife.tools.async.Defer;

    public interface IResourceDeserializer {

        function deserializeResourceAsync(bytes:ByteArray, url:String):Defer;

    }
}
