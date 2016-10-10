package scenes {

    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class RootChapter extends TartChapter {

        public function RootChapter() {
            trace("RootChapter :: new");
            addChapters(
                new Chapter_1(),
                new Chapter_2()
            );
        }

        public override function scenes():Array {
            return [
                Scene_Root
            ];
        }

        public override function awake():void {
            trace("RootChapter :: awake");
        }

        public override function initAsync():Defer {
            trace("RootChapter :: initAsync");
            return null;
        }

        public override function init():void {
            trace("RootChapter :: init");
        }

        public override function disposeAsync():Defer {
            trace("RootChapter :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("RootChapter :: dispose");
        }

        public override function assets():Array {
            trace("RootChapter :: assets");
            return null;
        }

        public override function initialActors():Array {
            trace("RootChapter :: initialActors");
            return null;
        }

    }
}
