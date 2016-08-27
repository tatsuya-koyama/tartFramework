package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_Stray_B extends TartScene {

        public function Scene_Stray_B() {}

        public override function awake():void {
            trace("Scene_Stray_B :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_Stray_B :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_Stray_B :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_Stray_B :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_Stray_B :: dispose");
        }

        public override function assets():Array {
            trace("Scene_Stray_B :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_Stray_B :: initialActors");
            return null;
        }

    }
}
