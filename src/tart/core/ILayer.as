package tart.core {

    /** Interface for layers such as graphics and collision. */
    public interface ILayer {

        /** Returns name to retrieve this layer object. */
        function get layerName():String;

        /** Returns scope object that this layer belongs. */
        function get layerScope():ISceneScope;

        /** Setter for scope object. */
        function set layerScope(scope:ISceneScope):void;

        /** Returns ActorCore instance that has behavior of this layer. */
        function get layerActor():ActorCore;

        /** [Optional] Returns data for convenience. */
        function get layerUserData():*;

        /** Called when this layer is created. */
        function onLayerCreated():void;

        /** Called when this layer is disposed. */
        function onLayerDisposed():void;

        /** Returns text that describes this layer. */
        function toString():String;

    }
}
