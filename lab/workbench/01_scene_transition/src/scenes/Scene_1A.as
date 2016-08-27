package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_1A extends TartScene {

        public function Scene_1A() {}

        public override function awake():void {
            trace("Scene_1A :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_1A :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_1A :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_1A :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_1A :: dispose");
        }

        public override function assets():Array {
            trace("Scene_1A :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_1A :: initialActors");
            return null;
        }

    }
}
