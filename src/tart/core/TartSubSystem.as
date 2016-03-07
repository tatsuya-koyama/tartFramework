package tart.core {

    public class TartSubSystem {

        public var priority:int = 0;

        private var _engine:TartEngine;

        protected var _tartContext:TartContext;

        public function get name():String {
            return "Default System Name";
        }

        public function set tartContext(ctx:TartContext):void {
            _tartContext = ctx;
            _engine      = ctx.engine;
        }

        public function process(deltaTime:Number):void {
            // Override in subclasses
        }

        protected function _getComponents(componentClass:Class):Array {
            return _engine.getComponents(componentClass);
        }

    }
}
