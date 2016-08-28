package tart.systems {

    import tart.core.tart_internal;
    import tart.core.TartSubSystem;

    use namespace tart_internal;

    public class ActorDestroySystem extends TartSubSystem {

        public override function get name():String {
            return "ActorDestroySystem";
        }

        public override function process(deltaTime:Number):void {
            _tartContext.engine.disposeDeadEntities();
        }

    }
}
