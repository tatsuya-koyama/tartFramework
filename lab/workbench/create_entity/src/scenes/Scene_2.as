package scenes {

    import tart.actors.Layer2D;
    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    import actors.*;

    // test
    import flash.utils.setTimeout;

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

            // test
            setTimeout(function():void {
                trace("\n\n");
                tart.director.navigateTo(new Scene_1());
            }, 5000);
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
                "lab_assets/sub_dir/atlas_game.png",
                "lab_assets/sub_dir/atlas_game.xml"
            ];
        }

        public override function layers():Array {
            trace("Scene_2 :: layers");
            return [
                 new Layer2D("f-back",   1, Layer2D.STARLING_FORE)
                ,new Layer2D("f-middle", 2, Layer2D.STARLING_FORE)
                ,new Layer2D("f-fore",   3, Layer2D.STARLING_FORE)

                ,new Layer2D("b-back",   1, Layer2D.STARLING_BACK)
                ,new Layer2D("b-middle", 2, Layer2D.STARLING_BACK)
                ,new Layer2D("b-fore",   3, Layer2D.STARLING_BACK)
            ];
        }

        public override function initialActors():Array {
            trace("Scene_2 :: initialActors");
            return [
                 new TestActor_1(300, 150, "piyo", "f-global")
                ,new TestActor_1(300, 280, "man",  "b-global")
            ];
        }

    }
}
