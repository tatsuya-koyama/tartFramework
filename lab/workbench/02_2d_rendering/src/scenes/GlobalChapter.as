package scenes {

    import tart.actors.Layer2D;
    import tart.core.TartChapter;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class GlobalChapter extends TartChapter {

        public override function scenes():Array {
            return [
                Scene_1,
                Scene_2
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

        public override function disposeAsync():Defer {
            trace("GlobalChapter :: disposeAsync");
            return null;
        }

        public override function dispose():void {
            trace("GlobalChapter :: dispose");
        }

        public override function assets():Array {
            trace("GlobalChapter :: assets");
            return [
                "lab_assets/piyo.png"
            ];
        }

        public override function layers():Array {
            trace("GlobalChapter :: layers");
            return [
                 new Layer2D("f-global", 99, Layer2D.STARLING_FORE)
                ,new Layer2D("b-global",  0, Layer2D.STARLING_BACK)
            ];
        }

        public override function initialActors():Array {
            trace("GlobalChapter :: initialActors");
            return null;
        }

    }
}
