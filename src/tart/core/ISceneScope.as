package tart.core {

    import dessert_knife.tools.async.Defer;

    /** Lifetime scope for entities and resources. */
    public interface ISceneScope {

        function getChildren():Vector.<ISceneScope>;

        /** Handler called before loading assets. */
        function awake():void;

        function initAsync():Defer;

        function init():void;

        function disposeAsync():Defer;

        function dispose():void;

        function assets():Array;

        function initialActors():Array;

    }
}