package actors {

    import starling.display.BlendMode;
    import starling.display.Image;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    public class Bullet extends ActorCore {

        public override function build():void {
            compose(Transform, View2D);
        }

        public function Bullet(x:Number, y:Number) {
            afterAwake(function():void {
                _transform.position.x = x;
                _transform.position.y = y;
            });
        }

        public override function awake():void {
            var image:Image = _view2D.makeImage('star', 'f-global', 24, 24);
            image.blendMode = BlendMode.NORMAL;
            image.color     = 0xffff77;
        }

        public override function update(deltaTime:Number):void {
            _transform.position.x += (900 * deltaTime);

            _transform.rotation.z += (4.0 * deltaTime);

            if (_transform.position.x > 980) {
                destroy();
            }
        }

    }
}
