package actors {

    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    public class View3DGenerator extends ActorCore {

        private var _elapsedTime:Number = 0;

        public override function build():void {
            compose(Transform, View2D);
        }

        public function View3DGenerator() {}

        public override function update(deltaTime:Number):void {
            _elapsedTime += deltaTime;

            var span:Number = 0.2;
            if (_elapsedTime > span) {
                _elapsedTime -= span;
                spawnActor(new View3DTester());
            }
        }

    }
}
