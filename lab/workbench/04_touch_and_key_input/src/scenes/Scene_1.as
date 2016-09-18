package scenes {

    import flash.utils.setTimeout;

    import tart.actors.Layer2D;
    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    import actors.*;

    public class Scene_1 extends TartScene {

        public function Scene_1() {}

        public override function awake():void {}

        public override function initAsync():Defer {
            return null;
        }

        public override function init():void {}

        public override function disposeAsync():Defer {
            return null;
        }

        public override function dispose():void {}

        public override function assets():Array {
            return null;
        }

        public override function layers():Array {
            return null;
        }

        public override function initialActors():Array {
            return [
                new MyShip()
            ];
        }

    }
}
