package dessert_knife.tools.random {

    /** Pseudo random number generator for unit tests. */
    public class DebugRandomizer implements IRandomizer {

        private var _nextValue:Number = 0;

        public function set nextValue(value:Number):void {
            _nextValue = value;
        }

        /** Returns dummy value. */
        public function random():Number {
            return _nextValue;
        }

        public function setSeed(seed:uint):void {
            // do nothing
        }

    }
}
