package tart.core {

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class TartScene implements ISceneScope {

        private var _tartContext:TartContext;

        public function TartScene() {}

        //----------------------------------------------------------------------
        // implements ISceneScope
        //----------------------------------------------------------------------

        public function get tart():TartContext {
            return _tartContext;
        }

        public function set tart(tartContext:TartContext):void {
            _tartContext = tartContext;
        }

        public function getChildren():Vector.<ISceneScope> {
            return null;
        }

        public function awake():void {

        }

        public function initAsync():Defer {
            return knife.defer().done();
        }

        public function init():void {

        }

        public function disposeAsync():Defer {
            return knife.defer().done();
        }

        public function dispose():void {

        }

        public function assets():Array {
            return null;
        }

        public function initialActors():Array {
            return null;
        }

    }
}
