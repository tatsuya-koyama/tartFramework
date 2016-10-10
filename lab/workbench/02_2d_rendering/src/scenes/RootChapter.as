package scenes {

    import tart.actors.Layer2D;
    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class RootChapter extends TartChapter {

        public override function scenes():Array {
            return [
                Scene_1,
                Scene_2
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
            return [
                "lab_assets/piyo.png"
            ];
        }

        public override function layers():Array {
            trace("RootChapter :: layers");
            return [
                 new Layer2D("f-global", 99, Layer2D.STARLING_FORE)
                ,new Layer2D("b-global",  0, Layer2D.STARLING_BACK)
            ];
        }

        public override function initialActors():Array {
            trace("RootChapter :: initialActors");
            return null;
        }

    }
}
