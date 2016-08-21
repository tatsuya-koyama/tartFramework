package dessert_knife.blades {

    import flash.utils.Dictionary;

    /**
     * Utilities for String.
     */
    public class StringKnife {

        private static const PAD_LEFT :int = 0;
        private static const PAD_RIGHT:int = 1;

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
         * Alias of checking if string contains some phrase.
         */
        public function contains(src:String, phrase:String):Boolean {
            return (src.indexOf(phrase) != -1);
        }

        /**
         * Returns file name of file path without extension.
         * Example: "path/to/file.txt" -> "file"
         */
        public function fileNameOf(filePath:String):String {
            var fileName:String = filePath.substring(
                filePath.lastIndexOf("/") + 1
            );
            if (!contains(fileName, ".")) {
                return fileName;
            }
            return fileName.substring(
                0, fileName.indexOf(".")
            );
        }

        /**
         * Returns extension of file path.
         * Example: "path/to/file.txt" -> "txt"
         */
        public function extensionOf(filePath:String):String {
            var parts:Array = filePath.split(".");
            return (parts.length >= 2) ? parts.pop() : null;
        }

        /**
         * Stringify Dictionary like Object.
         * This is useful in traditional print debugging.
         */
        public function stringifyDictionary(dict:Dictionary, space:int=4):String {
            var obj:Object = {};
            for (var key:String in dict) {
                obj[key] = dict[key];
            }
            return JSON.stringify(obj, null, space);
        }

        /**
         * Pads the left side of string with characters
         * until the string length reaches target length.
         *
         * <p>Example:</p>
         * <listing>
         *     padLeft("abc",     6, "-") -> "---abc"
         *     padLeft("ABCDEFG", 6, "-") -> "ABCDEFG"
         * </listing>
         */
        public function padLeft(srcStr:String, targetLength:int, padChar:String=" "):String {
            return _pad(srcStr, targetLength, padChar, PAD_LEFT);
        }

        /**
         * Pads the right side of string with characters
         * until the string length reaches target length.
         *
         * <p>Example:</p>
         * <listing>
         *     padRight("abc",     6, "-") -> "abc---"
         *     padRight("ABCDEFG", 6, "-") -> "ABCDEFG"
         * </listing>
         */
        public function padRight(srcStr:String, targetLength:int, padChar:String=" "):String {
            return _pad(srcStr, targetLength, padChar, PAD_RIGHT);
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _pad(srcStr:String, targetLength:int, padChar:String, padMode:int):String {
            if (srcStr.length >= targetLength) { return srcStr; }

            padChar = padChar.charAt(0) || " ";

            var paddedStr:String = srcStr;
            while (paddedStr.length < targetLength) {
                if (padMode == PAD_LEFT) {
                    paddedStr = padChar + paddedStr;
                } else {
                    paddedStr = paddedStr + padChar;
                }
            }
            return paddedStr;
        }

    }
}
