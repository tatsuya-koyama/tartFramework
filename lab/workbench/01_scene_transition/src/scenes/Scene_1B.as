package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_1B extends TartScene {

        public function Scene_1B() {}

        public override function awake():void {
            trace("Scene_1B :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_1B :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_1B :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_1B :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_1B :: dispose");
        }

        public override function assets():Array {
            trace("Scene_1B :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_1B :: initialActors");
            return null;
        }

    }
}
