package actors {

    import flash.geom.Vector3D;

    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.display.Sprite;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    import dessert_knife.knife;

    public class ActorGenerator extends ActorCore {

        private var _elapsedTime:Number = 0;
        private var _offsetPhase:Number = 0;

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function ActorGenerator() {
            _offsetPhase = knife.rand.float(99);
            afterAwake(function():void {
                var image:Image = _view2D.makeImage('piyo', 'f-global', 60, 60);
            });
        }

        public override function update(deltaTime:Number):void {
            _elapsedTime += deltaTime;

            var phase:Number = _elapsedTime + _offsetPhase;
            _transform.position.x = 480 + Math.sin(phase) * 200;
            _transform.position.y = 320 + Math.cos(phase) * 200;

            _transform.rotation.z = -0.2 + Math.sin(phase * 10) * 0.6;

            // Generate actor
            if (knife.rand.float(1.0) < 0.1) {
                var pos:Vector3D = _transform.position;
                spawnActor(new TestActor_1(pos.x, pos.y));
            }
        }

    }
}
