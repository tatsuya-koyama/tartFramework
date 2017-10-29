package actors {

    import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

    import starling.display.Image;
    import starling.events.Touch;

    import tart.components.KeyInput;
    import tart.components.Touch2D;
    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    public class MyShip extends ActorCore {

        private var _image:Image;
        private var _elapsedTime:Number;
        private var _lastShotAt:Number;

        public override function build():void {
            compose(Transform, View2D, KeyInput, Touch2D);
        }

        public function MyShip() {
            _elapsedTime = 0;
            _lastShotAt  = 0;
        }

        public override function awake():void {
            _transform.position.x = 240;
            _transform.position.y = 320;

            _image = _view2D.makeImage('piyo', 'f-global', 64, 64);
            _transform.scale.x *= -1.0;

            // keyboard handling test
            _keyInput.onKeyDown(function(event:KeyboardEvent):void {
                trace("- keyDown:", event.keyCode);
            });
            _keyInput.onKeyUp(function(event:KeyboardEvent):void {
                trace("- keyUp:", event.keyCode);
            });

            // setup touch handling
            _touch2D.width  = 64;
            _touch2D.height = 64;

            _touch2D.touchStartSignal.connect(_onTouchStart);
            _touch2D.touchMoveSignal.connect(_onTouchMove);
            _touch2D.touchEndSignal.connect(_onTouchEnd);
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
                    _transform.position.x + 30,
                    _transform.position.y
                ));
            }
        }

        private function _onTouchStart(touch:Touch):void {
            _image.color = 0xff9999;
        }

        private function _onTouchMove(touch:Touch, isHolding:Boolean):void {
            if (!isHolding) { return; }

            _transform.position.x = touch.globalX;
            _transform.position.y = touch.globalY;
        }

        private function _onTouchEnd(touch:Touch, isInside:Boolean):void {
            _image.color = 0xffffff;
        }

    }
}
