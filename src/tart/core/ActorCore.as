package tart.core {

    import tart.components.Transform;
    import tart.components.View2D;

    public class ActorCore extends Component {

        public var markedForDeath:Boolean = false;

        protected var _transform:Transform;
        protected var _view2D:View2D;

        public function get transform():Transform { return _transform; }
        public function get view2D():View2D { return _view2D; }

        private var _afterAwakeTask:Function;

        public function ActorCore() {}

        public override function getClass():Class {
            return ActorCore;
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function destroy():void {
            _entity.isAlive = false;
        }

        public override function recycle():void {
            super.recycle();

            _transform      = null;
            _view2D         = null;
            _afterAwakeTask = null;
        }

        //----------------------------------------------------------------------
        // protected
        //----------------------------------------------------------------------

        protected function attach(component:Component):Component {
            component.tart = this.tart;
            _entity.attach(component);
            return component;
        }

        protected function compose(...componentClasses):void {
            for each (var componentClass:Class in componentClasses) {
                // ToDo: pooling
                var component:Component = new componentClass() as Component;
                attach(component);
            }
        }

        protected function afterAwake(task:Function):void {
            _afterAwakeTask = task;
        }

        protected function spawnActor(actor:ActorCore):void {
            var newEntity:Entity = tart.engine.buildActor(actor);
            tart.engine.addEntityAfterUpdate(newEntity, _entity.scope);
        }

        //----------------------------------------------------------------------
        // Handlers for user code (please override in subclasses.)
        //----------------------------------------------------------------------

        public function build():void {}

        public function awake():void {}

        public function update(deltaTime:Number):void {}

        //----------------------------------------------------------------------
        // internal
        //----------------------------------------------------------------------

        tart_internal function internalAwake():void {
            _transform = getComponent(Transform) as Transform;
            _view2D    = getComponent(View2D) as View2D;

            if (_afterAwakeTask != null) {
                _afterAwakeTask();
            }
        }

    }
}
