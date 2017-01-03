package tart.systems {

    import away3d.containers.ObjectContainer3D;

    import starling.display.DisplayObject;

    import tart.components.Transform;
    import tart.core.ActorCore;
    import tart.core.TartGraphics;
    import tart.core.TartSubSystem;

    public class RenderSystem extends TartSubSystem {

        public override function get name():String {
            return "RenderSystem";
        }

        public override function process(deltaTime:Number):void {
            _applyTransformToView2D();
            _applyTransformToView3D();

            var graphics:TartGraphics = _tartContext.graphics;
            graphics.starlingBack.nextFrame();
            graphics.away3DView.render();
            graphics.starlingFore.nextFrame();
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _applyTransformToView2D():void {
            var actors:Array = _getComponents(ActorCore);
            for each (var actor:ActorCore in actors) {
                if (!actor.isAlive) { continue; }
                if (!actor.view2D || !actor.transform) { continue; }

                _updateView2DTransform(actor.transform, actor.view2D.displayObj);
                _updateView2DTransform(actor.transform, actor.view2D.displayObjContainer);
            }
        }

        private function _updateView2DTransform(transform:Transform, view:DisplayObject):void {
            if (!view) { return; }

            view.x = transform.position.x;
            view.y = transform.position.y;

            view.scaleX = transform.scale.x;
            view.scaleY = transform.scale.y;

            view.rotation = transform.rotation.z;
        }

        private function _applyTransformToView3D():void {
            var actors:Array = _getComponents(ActorCore);
            for each (var actor:ActorCore in actors) {
                if (!actor.isAlive) { continue; }
                if (!actor.view3D || !actor.transform) { continue; }

                _updateView3DTransform(actor.transform, actor.view3D.displayObjContainer);
            }
        }

        private function _updateView3DTransform(transform:Transform, view3D:ObjectContainer3D):void {
            if (!view3D) { return; }

            view3D.position = transform.position;

            view3D.scaleX = transform.scale.x;
            view3D.scaleY = transform.scale.y;
            view3D.scaleZ = transform.scale.z;

            view3D.rotateTo(
                transform.rotation.x,
                transform.rotation.y,
                transform.rotation.z
            );
        }

    }
}
