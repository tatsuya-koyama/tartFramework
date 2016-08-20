package tart.core {

    /** Interface for layers such as graphics and collision. */
    public interface ILayer {

        /** Returns name to retrieve this layer object. */
        function get layerName():String;

        /** Returns scope object that this layer belongs. */
        function get scope():ISceneScope;

        /** Setter for scope object. */
        function set scope(scope:ISceneScope):void;

        /** Returns TartActor instance that has behavior of this layer. */
        function get layerActor():TartActor;

        /** Called when this layer is created. */
        function onLayerCreated():void;

        /** Called when this layer is disposed. */
        function onLayerDisposed():void;

    }
}
