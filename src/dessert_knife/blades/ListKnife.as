package dessert_knife.blades {

    /**
     * Utilities for Array.
     */
    public class ListKnife {

        //----------------------------------------------------------------------
        // Instant accessor
        //----------------------------------------------------------------------

        private static var _instance:ListKnife;

        public static function get instance():ListKnife {
            if (!_instance) {
                _instance = new ListKnife();
            }
            return _instance;
        }

        //----------------------------------------------------------------------
        // utilities
        //----------------------------------------------------------------------

        /**
         * Alias of best way to clear an Array in AS3.
         */
        public function clear(list:Array):void {
            list.length = 0;
        }

        /**
         * Create a shallow-copied clone of source Array.
         * It is merely alias of Array.slice().
         */
        public function clone(src:Array):Array {
            return src.slice();
        }

    }
}
