package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_2B extends TartScene {

        public function Scene_2B() {}

        public override function awake():void {
            trace("Scene_2B :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_2B :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_2B :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_2B :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_2B :: dispose");
        }

        public override function assets():Array {
            trace("Scene_2B :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_2B :: initialActors");
            return null;
        }

    }
}
