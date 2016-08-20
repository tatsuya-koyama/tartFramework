package tart.components {

    import starling.display.DisplayObject;
    import starling.display.Image;

    import tart.core.Component;

    /**
     * 2D view component powered by Starling.
     */
    public class View2D extends Component {

        public var displayObj:DisplayObject;

        public override function getClass():Class {
            return View2D;
        }

        public override function reset():void {
            if (displayObj) {
                displayObj.removeFromParent(true);
                displayObj = null;
            }
        }

        //----------------------------------------------------------------------
        // helper methods
        //----------------------------------------------------------------------

        public function addImage():Image {
            // ToDo
            return null;
        }

    }
}
