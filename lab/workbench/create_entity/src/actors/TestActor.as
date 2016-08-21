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

        public function TestActor(x:Number, y:Number, imageName:String="piyo",
                                  layerName:String="f-fore")
        {
            afterAwake(function():void {
                _transform.position.x = x;
                _transform.position.y = y;
                _view2D.addImage(imageName, layerName);
            });
        }

        public override function update(deltaTime:Number):void {
            _transform.position.x += 1.0;
        }

    }
}
