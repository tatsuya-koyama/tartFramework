package dessert_knife.blades {

    import flash.utils.Dictionary;

    /**
     * Utilities for Dictionary.
     */
    public class MapKnife {

        //----------------------------------------------------------------------
        // Instant accessor
        //----------------------------------------------------------------------

        private static var _instance:MapKnife;

        public static function get instance():MapKnife {
            if (!_instance) {
                _instance = new MapKnife();
            }
            return _instance;
        }

        //----------------------------------------------------------------------
        // utilities
        //----------------------------------------------------------------------

        /**
         * Clear all values in dictionary.
         */
        public function clear(dict:Dictionary):void {
            for (var key:* in dict) {
                delete dict[key];
            }
        }

    }
}
