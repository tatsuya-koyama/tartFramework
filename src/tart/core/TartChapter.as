package tart.core {

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    /**
     * Large scope including Scenes.
     */
    public class TartChapter implements ISceneScope {

        public function TartChapter() {}

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function scenes():Array {
            return null;
        }

        public function addChapters(...args):void {

        }

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
