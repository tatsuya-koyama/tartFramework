package actors {

    import starling.display.Image;
    import starling.display.Sprite;

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.TartActor;

    public class TestActor_1 extends TartActor {

        public override function recipe():Array {
            return [
                Transform, View2D
            ];
        }

        public function TestActor_1() {

        }

        public override function update(deltaTime:Number):void {

        }

    }
}
