package actors {

    import flash.geom.Vector3D;

    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.display.Sprite;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.TartActor;

    import dessert_knife.knife;

    public class TestActor_1 extends TartActor {

        private var _speed:Vector3D;
        private var _elapsedTime:Number = 0;

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function TestActor_1(x:Number, y:Number) {
            afterAwake(function():void {
                _transform.position.x = x;
                _transform.position.y = y;
                var image:Image = _view2D.makeImage('dust', 'f-global');
                image.blendMode = BlendMode.SCREEN;

                var vx:Number = knife.rand.float(-4, 4);
                var vy:Number = knife.rand.float(-4, 4);
                _speed = new Vector3D(vx, vy, 0);
            });
        }

        public override function update(deltaTime:Number):void {
            _transform.position.x += _speed.x;
            _transform.position.y += _speed.y;

            _elapsedTime += deltaTime;
            if (_elapsedTime > 3.0) {
                destroy();
            }
        }

    }
}
