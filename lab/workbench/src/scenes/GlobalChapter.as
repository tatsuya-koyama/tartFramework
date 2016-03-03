package scenes {

    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class GlobalChapter extends TartChapter {

        public function GlobalChapter() {
            trace("GlobalChapter :: new");
            addChapters(
                new Chapter_1(),
                new Chapter_2()
            );
        }

        public override function scenes():Array {
            return [
                Scene_Global
            ];
        }

        public override function awake():void {
            trace("GlobalChapter :: awake");
        }

        public override function initAsync():Defer {
            trace("GlobalChapter :: initAsync");
            return null;
        }

        public override function init():void {
            trace("GlobalChapter :: init");
        }

        public override function assets():Array {
            trace("GlobalChapter :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("GlobalChapter :: initialActors");
            return null;
        }

    }
}
