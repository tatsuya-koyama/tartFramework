package tart.core {

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class TartScene implements ISceneScope {

        public function TartScene() {}

        //----------------------------------------------------------------------
        // implements ISceneScope
        //----------------------------------------------------------------------

        public function awake():void {

        }

        public function initAsync():Defer {
            return null;
        }

        public function init():void {

        }

        public function assets():Array {
            return null;
        }

        public function initialActors():Array {
            return null;
        }

    }
}
