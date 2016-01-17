package dessert_knife.tools.random {

    public class XorShiftRandomizer implements IRandomizer {

        private const MAX:uint = uint.MAX_VALUE / 2;

        private var x:uint = 123456789;
        private var y:uint = 362436069;
        private var z:uint = 521288629;
        private var w:uint = 88675123;
        private var t:uint;

        public function XorShiftRandomizer(seed:uint=12345678) {
            setSeed(seed);
        }

        //----------------------------------------------------------------------
        // IRandomizer implementation
        //----------------------------------------------------------------------

        public function random():Number {
            return (_generateUintRandom() % MAX) / MAX;
        }

        /**
         * <p>
         * [Note] XorShift is fast and easy to implement, but has a minor problem
         *        of deviation; some of its initial values tend to be biased.
         *        To prevent this, skip first 8 numbers in advance.
         * </p>
         * <p>
         * [Note] XorShift は乱数生成器として軽量で手頃だが、初期に生成される値の並びが
         *        偏りやすい傾向がある。ここでは seed の値を設定した後に 8 回読み飛ばしを
         *        行うことで、この偏りを回避する。
         * </p>
         */
        public function setSeed(seed:uint):void {
            x = seed = 1812433253 * (seed ^ (seed >> 30)) + 0;
            y = seed = 1812433253 * (seed ^ (seed >> 30)) + 1;
            z = seed = 1812433253 * (seed ^ (seed >> 30)) + 2;
            w = seed = 1812433253 * (seed ^ (seed >> 30)) + 3;

            for (var i:int = 0;  i < 8;  ++i) {
                random();
            }
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _generateUintRandom():uint {
            t = x ^ (x << 11);
            x = y;
            y = z;
            z = w;
            w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
            return w;
        }

    }
}
