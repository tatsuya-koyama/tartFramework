package tart.core {

    import dessert_knife.tools.async.Defer;

    /** Lifetime scope for entities and resources. */
    public interface ISceneScope {

        /** Handler called before loading assets. */
        function awake():void;

        function initAsync():Defer;

        function init():void;

        function assets():Array;

        function initialActors():Array;

    }
}
