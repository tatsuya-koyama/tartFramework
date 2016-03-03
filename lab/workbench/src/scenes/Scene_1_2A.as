package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_1_2A extends TartScene {

        public function Scene_1_2A() {}

        public override function awake():void {
            trace("Scene_1_2A :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_1_2A :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_1_2A :: init");
        }

        public override function assets():Array {
            trace("Scene_1_2A :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_1_2A :: initialActors");
            return null;
        }

    }
}
