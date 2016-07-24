package tart.systems {

    import tart.core.TartActor;
    import tart.core.TartGraphics;
    import tart.core.TartSubSystem;

    public class RenderSystem extends TartSubSystem {

        public override function get name():String {
            return "RenderSystem";
        }

        public override function process(deltaTime:Number):void {
            _applyTransformToView2D();

            var graphics:TartGraphics = _tartContext.graphics;
            graphics.starlingBack.nextFrame();
            graphics.away3DView.render();
            graphics.starlingFore.nextFrame();
        }

        private function _applyTransformToView2D():void {
            var actors:Array = _getComponents(TartActor);
            for each (var actor:TartActor in actors) {
                if (!actor.isAlive) { continue; }
                if (!actor.view2D || !actor.transform) { continue; }

                // ToDo: Dirty なものだけ処理する
                actor.view2D.displayObj.x = actor.transform.position.x;
                actor.view2D.displayObj.y = actor.transform.position.y;
            }
        }

    }
}
