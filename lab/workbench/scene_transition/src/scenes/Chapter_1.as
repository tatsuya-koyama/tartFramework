package scenes {

    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    import flash.utils.setTimeout;

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

            var defer:Defer = knife.defer();
            setTimeout(function():void { trace("."); }, 300);
            setTimeout(function():void { trace("o"); }, 600);
            setTimeout(function():void { trace("@"); }, 900);
            setTimeout(defer.done, 1200);
            return defer;
        }

        public override function init():void {
            trace("Chapter_1 :: init");
        }

        public override function disposeAsync():Defer {
            trace("Chapter_1 :: disposeAsync");

            var defer:Defer = knife.defer();
            setTimeout(function():void { trace("@"); }, 300);
            setTimeout(function():void { trace("o"); }, 600);
            setTimeout(function():void { trace("."); }, 900);
            setTimeout(defer.done, 1200);
            return defer;
        }

        public override function dispose():void {
            trace("Chapter_1 :: dispose");
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
