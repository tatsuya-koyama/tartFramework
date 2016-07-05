package tart.systems {

    import tart.core.tart_internal;
    import tart.core.TartSubSystem;

    use namespace tart_internal;

    public class DirectionSystem extends TartSubSystem {

        public override function get name():String {
            return "DirectionSystem";
        }

        public override function process(deltaTime:Number):void {
            _tartContext.director.processTransition();
        }

    }
}
