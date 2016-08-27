package tart.components {

    import flash.geom.Rectangle;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Image;
    import starling.display.Sprite;

    import tart.core.Component;
    import tart.core.ILayer;

    /**
     * 2D view component powered by Starling.
     */
    public class View2D extends Component {

        public var displayObj:DisplayObject;
        public var displayObjContainer:DisplayObjectContainer;

        public override function getClass():Class {
            return View2D;
        }

        public override function reset():void {
            if (displayObj) {
                displayObj.removeFromParent(true);
                displayObj = null;
            }
            if (displayObjContainer) {
                displayObjContainer.removeChildren();
                displayObjContainer.dispose();
                displayObjContainer = null;
            }
        }

        //----------------------------------------------------------------------
        // helper methods
        //----------------------------------------------------------------------

        public function makeImage(imageName:String, layerName:String=null,
                                  width:Number=NaN, height:Number=NaN,
                                  anchorX:Number=0.5, anchorY:Number=0.5):Image
        {
            var image:Image = _makeImage(imageName, width, height, anchorX, anchorY);
            displayObj = image;

            _addViewToLayer(image, layerName);
            return image;
        }

        public function makeSprite(layerName:String=null):Sprite {
            var sprite:Sprite = new Sprite();
            displayObjContainer = sprite;

            _addViewToLayer(sprite, layerName);
            return sprite;
        }

        public function addImage(imageName:String, parentView:DisplayObjectContainer,
                                 offsetX:Number=0, offsetY:Number=0,
                                 width:Number=NaN, height:Number=NaN,
                                 anchorX:Number=0.5, anchorY:Number=0.5):Image
        {
            var image:Image = _makeImage(imageName, width, height, anchorX, anchorY);
            image.x = offsetX;
            image.y = offsetY;

            parentView.addChild(image);
            return image;
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _makeImage(imageName:String,
                                    width:Number=NaN, height:Number=NaN,
                                    anchorX:Number=0.5, anchorY:Number=0.5):Image
        {
            var image:Image = tart.resource.getImage(imageName);
            if (!isNaN(width )) { image.width  = width;  }
            if (!isNaN(height)) { image.height = height; }
            _setImageAnchor(image, anchorX, anchorY);
            return image;
        }

        private function _setImageAnchor(image:Image, anchorX:Number, anchorY:Number):Image {
            var textureRect:Rectangle = image.texture.frame;
            if (textureRect) {
                image.pivotX = textureRect.width  * anchorX;
                image.pivotY = textureRect.height * anchorY;
            } else {
                image.pivotX = image.texture.width  * anchorX;
                image.pivotY = image.texture.height * anchorY;
            }
            return image;
        }

        private function _addViewToLayer(view:DisplayObject, layerName:String):void {
            if (!layerName) { return; }

            var layer:ILayer = tart.layers.getLayer(layerName);
            if (!(layer.layerUserData is DisplayObjectContainer)) {
                TART::LOG_ERROR {
                    trace("[Error :: View2D] 2D layer <", layerName,
                          "> should have DisplayObjectContainer");
                }
                return;
            }

            var layerNode:DisplayObjectContainer = layer.layerUserData as DisplayObjectContainer;
            layerNode.addChild(view);
        }

    }
}
