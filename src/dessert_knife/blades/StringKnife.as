package dessert_knife.blades {

    /**
     * Utilities for String.
     */
    public class StringKnife {

        //----------------------------------------------------------------------
        // Instant accessor
        //----------------------------------------------------------------------

        private static var _instance:StringKnife;

        public static function get instance():StringKnife {
            if (!_instance) {
                _instance = new StringKnife();
            }
            return _instance;
        }

        //----------------------------------------------------------------------
        // utilities
        //----------------------------------------------------------------------

        /**
         * Returns extension of file path.
         * Example: "path/to/file.txt" -> "txt"
         */
        public function extensionOf(filePath:String):String {
            var parts:Array = filePath.split(".");
            return (parts.length >= 2) ? parts.pop() : null;
        }

    }
}
