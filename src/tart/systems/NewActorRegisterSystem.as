package tart.systems {

    import tart.core.tart_internal;
    import tart.core.TartSubSystem;

    use namespace tart_internal;

    public class NewActorRegisterSystem extends TartSubSystem {

        public override function get name():String {
            return "NewActorRegisterSystem";
        }

        public override function process(deltaTime:Number):void {
            _tartContext.engine.addPendingEntities();
        }

    }
}
