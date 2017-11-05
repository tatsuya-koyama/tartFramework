package actors {

    import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

    import starling.display.Image;

    import tart.components.KeyInput;
    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    public class MyShip extends ActorCore {

        private var _elapsedTime:Number;
        private var _lastShotAt:Number;

        public override function build():void {
            compose(Transform, View2D, KeyInput);
        }

        public function MyShip() {
            _elapsedTime = 0;
            _lastShotAt  = 0;
        }

        public override function awake():void {
            _transform.position.x = 240;
            _transform.position.y = 320;

            var image:Image = _view2D.makeImage('piyo', 'f-global', 64, 64);
            _transform.scale.x *= -1.0;
        }

        public override function update(deltaTime:Number):void {
            _steer(deltaTime);
            _shoot(deltaTime);
        }

        private function _steer(deltaTime:Number):void {
            var direction:Vector3D = _keyInput.getDirection();
            const speed:Number = 400;
            _transform.position.x += (direction.x * speed * deltaTime);
            _transform.position.y += (direction.y * speed * deltaTime);
        }

        private function _shoot(deltaTime:Number):void {
            if (!_keyInput.isPressed(Keyboard.Z)) { return; }

            const shotInterval:Number = 0.07;
            _elapsedTime += deltaTime;
            if (_elapsedTime - _lastShotAt > shotInterval) {
                _lastShotAt += shotInterval;
                spawnActor(new Bullet(
                    _transform.position.x + 40,
                    _transform.position.y
                ));
            }
        }

    }
}
