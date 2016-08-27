package scenes {

    import tart.actors.Layer2D;
    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class GlobalChapter extends TartChapter {

        public override function scenes():Array {
            return [
                Scene_1
            ];
        }

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
            return [
                "lab_assets/piyo.png",
                "lab_assets/dust.png",
                "lab_assets/atlas_world.png",
                "lab_assets/atlas_world.xml",
                "lab_assets/sub_dir/atlas_game.png",
                "lab_assets/sub_dir/atlas_game.xml"
            ];
        }

        public override function layers():Array {
            return [
                 new Layer2D("f-global", 99, Layer2D.STARLING_FORE)
                ,new Layer2D("b-global",  0, Layer2D.STARLING_BACK)
            ];
        }

        public override function initialActors():Array {
            return null;
        }

    }
}
