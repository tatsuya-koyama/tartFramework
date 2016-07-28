package tart.core {

    import tart.components.Transform;
    import tart.components.View2D;

    public class TartActor extends Component {

        public var tart:TartContext;
        public var awakened:Boolean = false;

        protected var _transform:Transform;
        protected var _view2D:View2D;

        public function get transform():Transform { return _transform; }
        public function get view2D():View2D { return _view2D; }

        private var _afterAwakeTask:Function;

        public function TartActor() {

        }

        public override function getClass():Class {
            return TartActor;
        }

        public function recipe():Array {
            return null;
        }

        protected function afterAwake(task:Function):void {
            _afterAwakeTask = task;
        }

        tart_internal function internalAwake():void {
            _transform = getComponent(Transform) as Transform;
            _view2D    = getComponent(View2D) as View2D;

            if (_afterAwakeTask != null) {
                _afterAwakeTask();
            }
        }

        public function awake():void {

        }

        public function update(deltaTime:Number):void {

        }

    }
}
