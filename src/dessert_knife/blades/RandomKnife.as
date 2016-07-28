package dessert_knife.blades {

    import dessert_knife.tools.random.DefaultRandomizer;
    import dessert_knife.tools.random.XorShiftRandomizer;
    import dessert_knife.tools.random.IRandomizer;

    /**
     * Utilities related to the random number and randomizer.
     */
    public class RandomKnife {

        private var _randomizer:IRandomizer;

        public function RandomKnife(randomizer:IRandomizer=null) {
            _randomizer = randomizer || new DefaultRandomizer();
        }

        //----------------------------------------------------------------------
        // Instant accessor
        //----------------------------------------------------------------------

        private static var _instance:RandomKnife;

        public static function get instance():RandomKnife {
            if (!_instance) {
                _instance = new RandomKnife();
            }
            return _instance;
        }

        //----------------------------------------------------------------------
        // utilities
        //----------------------------------------------------------------------

        /**
         * Returns floating random number in the range [min, max).
         *
         * <p>Example:</p>
         * <listing>
         *     float()      -> [ 0.0, Number.MAX_VALUE)
         *     float(5)     -> [ 0.0, 5.0)  // 5.0 is not inclusive.
         *     float(-5)    -> [-5.0, 0.0)  // 0.0 is not inclusive.
         *     float(2, 4)  -> [ 2.0, 4.0)
         *     float(4, 2)  -> [ 2.0, 4.0)  // swapping is OK.
         *     float(-3, 3) -> [-3.0, 3.0)
         * </listing>
         */
        public function float(min:Number=Number.MAX_VALUE, max:Number=NaN):Number {
            if (isNaN(max)) {
                max = min;
                min = 0;
            }
            if (max < min) {
                var tmp:Number = max;
                max = min;
                min = tmp;
            }
            return min + (_random() * (max - min));
        }

        /**
         * Returns integer random number in the range [min, max) or [min, max].
         *
         * <p>Example:</p>
         * <listing>
         *     integer()      -> any of  0, 1, ..., (int.MAX_VALUE - 1)
         *     integer(5)     -> any of  0, 1, 2, 3, 4       // 5 is not inclusive.
         *     integer(-5)    -> any of  -5, -4, -3, -2, -1  // 0 is not inclusive.
         *     integer(2, 4)  -> any of  2, 3, 4             // Unlike float(), 4 is inclusive.
         *     integer(4, 2)  -> any of  2, 3, 4             // swapping is OK.
         *     integer(-3, 3) -> any of  -3, -2, -1, 0, 1, 2, 3
         * </listing>
         */
        public function integer(min:Number=int.MAX_VALUE, max:Number=NaN):int {
            if (!isNaN(max)) {
                if (max > min) {
                    max += 1.0;
                } else {
                    min += 1.0;
                }
            }
            if (Math.abs(min) > int.MAX_VALUE ||
                Math.abs(max) > int.MAX_VALUE)
            {
                throw new Error("[Error :: RandomKnife.integer] min or max is too large: "
                                + min + ", " + max);
            }
            return Math.floor(this.float(min, max));
        }

        /**
         * Creates and returns new RandomKnife instance with given <code>randomizer</code>
         * and <code>seed</code>. If no <code>randomizer</code> given, XorShiftRandomizer
         * is used as a default.
         *
         * <p>Example:</p>
         * <listing>
         *     seeded(12345).float(); -> (Returns reproducible random number)
         * </listing>
         */
        public function seeded(seed:uint=0, randomizer:IRandomizer=null):RandomKnife {
            var newRandomizer:IRandomizer = randomizer || new XorShiftRandomizer(seed);
            return new RandomKnife(newRandomizer);
        }

        public function setRandomizer(randomizer:IRandomizer):void {
            _randomizer = randomizer;
        }

        public function setSeed(seed:uint):void {
            _randomizer.setSeed(seed);
        }

        /**
         * Returns copy of the list shuffled by the Fisher-Yates shuffle algorithm.
         * If null is given, returns empty array.
         */
        public function shuffle(list:Array):Array {
            var shuffled:Array = [];

            var index:int = 0;
            for each (var val:* in list) {
                var randIndex:int = this.integer(0, index);
                shuffled[index]     = shuffled[randIndex];
                shuffled[randIndex] = val;
                ++index;
            }

            return shuffled;
        }

        /**
         * Returns a random element in the array.
         * If given array is empty, returns null.
         */
        public function sample(list:Array):* {
            if (list.length == 0) { return null; }

            var index:int = this.integer(0, list.length - 1);
            return list[index];
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        /** Returns random number in the range [0, 1). */
        private function _random():Number {
            return _randomizer.random();
        }

    }
}
