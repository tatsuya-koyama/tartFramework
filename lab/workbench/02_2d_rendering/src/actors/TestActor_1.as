package actors {

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.TartActor;

    public class TestActor_1 extends TartActor {

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function TestActor_1(x:Number, y:Number, imageName:String="piyo",
                                    layerName:String="f-fore")
        {
            afterAwake(function():void {
                _transform.position.x = x;
                _transform.position.y = y;
                _view2D.makeImage(imageName, layerName);
            });
        }

        public override function update(deltaTime:Number):void {
            _transform.position.x += 1.0;
            _transform.rotation.z += 0.1;
        }

    }
}
