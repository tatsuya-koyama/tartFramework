package scenes {

    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class Chapter_1 extends TartChapter {

        public function Chapter_1() {
            trace("Chapter_1 :: new");
            addChapters(
                new Chapter_1_2()
            );
        }

        public override function scenes():Array {
            return [
                Scene_1A,
                Scene_1B
            ];
        }

        public override function awake():void {
            trace("Chapter_1 :: awake");
        }

        public override function initAsync():Defer {
            trace("Chapter_1 :: initAsync");
            return null;
        }

        public override function init():void {
            trace("Chapter_1 :: init");
        }

        public override function assets():Array {
            trace("Chapter_1 :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("Chapter_1 :: initialActors");
            return null;
        }

    }
}
