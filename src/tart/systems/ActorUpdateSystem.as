package tart.systems {

    import tart.core.TartActor;
    import tart.core.TartSubSystem;

    public class ActorUpdateSystem extends TartSubSystem {

        public override function get name():String {
            return "ActorUpdateSystem";
        }

        public override function process(deltaTime:Number):void {
            var actors:Array = _getComponents(TartActor);
            _updateActors(actors, deltaTime);
        }

        private function _updateActors(actors:Array, deltaTime:Number):void {
            for each (var actor:TartActor in actors) {
                if (!actor.isAlive) { continue; }
                actor.update(deltaTime);
            }
        }

    }
}
