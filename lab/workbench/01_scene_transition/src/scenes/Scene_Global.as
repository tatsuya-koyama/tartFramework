package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_Global extends TartScene {

        public function Scene_Global() {}

        public override function awake():void {
            trace("Scene_Global :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_Global :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_Global :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_Global :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_Global :: dispose");
        }

        public override function assets():Array {
            trace("Scene_Global :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_Global :: initialActors");
            return null;
        }

    }
}
