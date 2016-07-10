package actors {

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.TartActor;

    import DebugContext;

    public class TestActor extends TartActor {

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function TestActor(x:Number, y:Number) {
            afterAwake(function():void {
                _transform.position.x = x;
                _transform.position.y = y;
            });
        }

        public override function awake():void {
            var image:Image = DebugContext.tartContext.resource.getImage("piyo");
            _view2D.displayObj = image;

            var rootSprite:Sprite = DebugContext.tartContext.graphics.starlingFore.root as Sprite;
            rootSprite.addChild(_view2D.displayObj);
        }

        public override function update(deltaTime:Number):void {

        }

    }
}
