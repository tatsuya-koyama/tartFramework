package scenes {

    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Chapter_1_2 extends TartChapter {

        public function Chapter_1_2() {
            trace("Chapter_1_2 :: new");
        }

        public override function scenes():Array {
            return [
                Scene_1_2A,
                Scene_1_2B
            ];
        }

        public override function awake():void {
            trace("Chapter_1_2 :: awake");
        }

        public override function initAsync():Defer {
            trace("Chapter_1_2 :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Chapter_1_2 :: init");
        }

        public override function assets():Array {
            trace("Chapter_1_2 :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Chapter_1_2 :: initialActors");
            return null;
        }

    }
}
