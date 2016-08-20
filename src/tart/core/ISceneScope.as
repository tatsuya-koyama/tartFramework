package tart.core {

    import dessert_knife.tools.async.Defer;

    /** Lifetime scope for entities and resources. */
    public interface ISceneScope {

        function get tart():TartContext;

        function set tart(tartContext:TartContext):void;

        function getChildren():Vector.<ISceneScope>;

        /** Handler called before loading assets. */
        function awake():void;

        function initAsync():Defer;

        function init():void;

        function disposeAsync():Defer;

        function dispose():void;

        /** @return String[] - Paths of resource files used in this scope. */
        function assets():Array;

        /** @return ILayer2D[] - Instances of ILayer2D used in this scope. */
        function layers():Array;

        function initialActors():Array;

    }
}
