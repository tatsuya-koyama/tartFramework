package tart.components {

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;

    import tart.core.Component;
    import tart.core.ILayer;

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

        public function addImage(imageName:String, layerName:String):Image {
            var image:Image = tart.resource.getImage(imageName);
            displayObj = image;

            var layer:ILayer = tart.layers.getLayer(layerName);
            var layerSprite:Sprite = layer.layerUserData as Sprite;
            layerSprite.addChild(displayObj);

            return image;
        }

    }
}
