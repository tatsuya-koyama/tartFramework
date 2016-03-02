package tart.core {

    public class TartSubSystem {

        public var priority:int = 0;

        protected var _tartContext:TartContext;

        public function get name():String {
            return "Default System Name";
        }

        public function set tartContext(ctx:TartContext):void {
            _tartContext = ctx;
        }

        public function process(deltaTime:Number):void {
            // Override in subclasses
        }

    }
}
