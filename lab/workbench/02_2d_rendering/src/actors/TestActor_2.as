package actors {

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    public class TestActor_2 extends ActorCore {

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function TestActor_2(x:Number, y:Number) {
            afterAwake(function():void {
                _transform.position.x = x;
                _transform.position.y = y;
            });
        }

        public override function awake():void {
            var sprite:Sprite = _view2D.makeSprite("f-middle");
            _view2D.addImage("tree_1", sprite,    0,    0, 300 * 0.8, 500 * 0.8);
            _view2D.addImage("tree_1", sprite, -100, -150, 300 * 0.4, 500 * 0.4);
            _view2D.addImage("tree_1", sprite,   80, -180, 300 * 0.3, 500 * 0.3);
        }

        public override function update(deltaTime:Number):void {
            _transform.rotation.z += 0.03;
        }

    }
}
