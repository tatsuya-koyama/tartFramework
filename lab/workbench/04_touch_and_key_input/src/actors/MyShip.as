package actors {

    import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;

    import starling.display.BlendMode;
    import starling.display.Image;
    import starling.display.Sprite;

    import tart.components.KeyInput;
    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    import dessert_knife.knife;

    public class MyShip extends ActorCore {

        private var _keyInput:KeyInput;

        public override function build():void {
            compose(Transform, View2D);
            _keyInput = attach(KeyInput);
        }

        public function MyShip() {}

        public override function awake():void {
            _transform.position.x = 240;
            _transform.position.y = 320;

            var image:Image = _view2D.makeImage('piyo', 'f-global', 64, 64);
            _transform.scale.x *= -1.0;

            // test
            _keyInput.onKeyDown(function(event:KeyboardEvent):void {
                trace("- keyDown:", event.keyCode);
            });
            _keyInput.onKeyUp(function(event:KeyboardEvent):void {
                trace("- keyUp:", event.keyCode);
            });
        }

        public override function update(deltaTime:Number):void {
            var direction:Vector3D = _keyInput.getDirection();
            const speed:Number = 400;
            _transform.position.x += (direction.x * speed * deltaTime);
            _transform.position.y += (direction.y * speed * deltaTime);
        }

    }
}
