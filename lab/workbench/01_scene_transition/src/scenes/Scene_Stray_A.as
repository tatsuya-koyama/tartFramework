package scenes {

    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Scene_Stray_A extends TartScene {

        public function Scene_Stray_A() {}

        public override function awake():void {
            trace("Scene_Stray_A :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_Stray_A :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_Stray_A :: init");
        }

        public override function disposeAsync():Defer {
            trace("Scene_Stray_A :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_Stray_A :: dispose");
        }

        public override function assets():Array {
            trace("Scene_Stray_A :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Scene_Stray_A :: initialActors");
            return null;
        }

    }
}
