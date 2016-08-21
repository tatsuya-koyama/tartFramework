package scenes {

    import tart.actors.Layer2D;
    import tart.core.TartScene;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    import actors.*;

    // testing
    import flash.utils.setTimeout;

    public class Scene_1 extends TartScene {

        public function Scene_1() {}

        public override function awake():void {
            trace("Scene_1 :: awake");
        }

        public override function initAsync():Defer {
            trace("Scene_1 :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Scene_1 :: init");

            // testing
            setTimeout(function():void {
                trace("\n\n");
                tart.director.navigateTo(new Scene_2());
            }, 3000);
        }

        public override function disposeAsync():Defer {
            trace("Scene_1 :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("Scene_1 :: dispose");
        }

        public override function assets():Array {
            trace("Scene_1 :: assets");
            return [
                "lab_assets/piyo.png",
                "lab_assets/dust.png",
                "lab_assets/piyo.png",
                "lab_assets/dust.png",
                "lab_assets/atlas_world.png",
                "lab_assets/atlas_world.xml",
                "lab_assets/sub_dir/atlas_game.png",
                "lab_assets/sub_dir/atlas_game.xml"
            ];
        }

        public override function layers():Array {
            trace("Scene_1 :: layers");
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
            trace("Scene_1 :: initialActors");
            return [
                 new TestActor(200, 200, "circle_jiro",    "f-fore")
                ,new TestActor( 70, 100, "piyo",           "f-back")
                ,new TestActor(150, 150, "rectangle_taro", "f-middle")
                ,new TestActor(150, 280, "red_button",     "b-fore")
            ];
        }

    }
}
