package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    import actors.*;

    public class Scene_2 extends TartScene {

        public function Scene_2() {}

        public override function awake():void {
            trace("Scene_2 :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_2 :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_2 :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_2 :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_2 :: dispose");
        }

        public override function assets():Array {
            trace("Scene_2 :: assets");
            return [
                "lab_assets/piyo.png",
                "lab_assets/dust.png",
                "lab_assets/piyo.png",
            ];
        }

        public override function initialActors():Array {
            trace("Scene_2 :: initialActors");
            return null;
        }

    }
}
