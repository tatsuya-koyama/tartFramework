package tart.systems {

    import tart.core.TartSubSystem;

    public class DirectionSystem extends TartSubSystem {

        public override function get name():String {
            return "DirectionSystem";
        }

        public override function process(deltaTime:Number):void {
            _tartContext.director.processTransition();
        }

    }
}
