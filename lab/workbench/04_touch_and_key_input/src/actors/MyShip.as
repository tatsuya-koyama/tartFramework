package actors {

    import flash.geom.Vector3D;

    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.display.Sprite;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    import dessert_knife.knife;

    public class MyShip extends ActorCore {

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function MyShip() {}

        public override function awake():void {
            _transform.position.x = 240;
            _transform.position.y = 320;

            var image:Image = _view2D.makeImage('piyo', 'f-global', 64, 64);
            _transform.scale.x *= -1.0;
        }

        public override function update(deltaTime:Number):void {}

    }
}
