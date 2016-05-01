package actors {

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.TartActor;

    import DebugContext;

    public class TestActor extends TartActor {

        [Embed(source="../../../../lab_assets/piyo.png")]
        private static var PiyoImg:Class;

        private var _x:Number;
        private var _y:Number;

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function TestActor(x:Number, y:Number) {
            _x = x;
            _y = y;
        }

        public override function awake():void {
            var texture:Texture = Texture.fromEmbeddedAsset(PiyoImg);
            var image:Image     = new Image(texture);
            _view2D.displayObj  = image;

            var rootSprite:Sprite = DebugContext.tartContext.graphics.starlingFore.root as Sprite;
            rootSprite.addChild(_view2D.displayObj);

            _transform.position.x = _x;
            _transform.position.y = _y;
        }

        public override function update(deltaTime:Number):void {

        }

    }
}
