package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_Root extends TartScene {

        public function Scene_Root() {}

        public override function awake():void {
            trace("Scene_Root :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_Root :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_Root :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_Root :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_Root :: dispose");
        }

        public override function assets():Array {
            trace("Scene_Root :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_Root :: initialActors");
            return null;
        }

    }
}
