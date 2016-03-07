package tart.systems {

    import tart.core.TartGraphics;
    import tart.core.TartSubSystem;

    public class RenderSystem extends TartSubSystem {

        public override function get name():String {
            return "RenderSystem";
        }

        public override function process(deltaTime:Number):void {
            var graphics:TartGraphics = _tartContext.graphics;
            graphics.starlingBack.nextFrame();
            graphics.away3DView.render();
            graphics.starlingFore.nextFrame();
        }

    }
}
