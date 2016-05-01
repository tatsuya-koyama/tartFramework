package tart.core {

    import tart.components.Transform;
    import tart.components.View2D;

    public class TartActor extends Component {

        public var awakened:Boolean = false;

        protected var _transform:Transform;
        protected var _view2D:View2D;

        public function get transform():Transform { return _transform; }
        public function get view2D():View2D { return _view2D; }

        public function TartActor() {

        }

        public override function getClass():Class {
            return TartActor;
        }

        public function recipe():Array {
            return null;
        }

        internal function internalAwake():void {
            _transform = getComponent(Transform) as Transform;
            _view2D    = getComponent(View2D) as View2D;
        }

        public function awake():void {

        }

        public function update(deltaTime:Number):void {

        }

    }
}
