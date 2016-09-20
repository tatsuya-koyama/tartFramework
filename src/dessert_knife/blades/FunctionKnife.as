package dessert_knife.blades {

    /**
     * Utilities for Function in AS3.
     */
    public class FunctionKnife {

        //----------------------------------------------------------------------
        // Instant accessor
        //----------------------------------------------------------------------

        private static var _instance:FunctionKnife;

        public static function get instance():FunctionKnife {
            if (!_instance) {
                _instance = new FunctionKnife();
            }
            return _instance;
        }

        //----------------------------------------------------------------------
        // utilities
        //----------------------------------------------------------------------

        /**
         * <p>
         * Call function with flexible arguments like a JavaScript.
         * In AS3, if argument count mismatch occurs, runtime throws ArgumentError.
         * This method silences the runtime error.
         * (Excess args will be truncated and lacking args will be filled with null.)
         * </p>
         *
         * <p>
         * JS のように引数の数に対して寛容に関数を呼ぶヘルパー。
         * AS3 は Function のスキーマを静的に解決できないくせに引数の数が異なると
         * 実行時に ArgumentError を投げるので、それを封じ込めるためのもの。
         * （超過分の引数は捨てられ、不足分は null で埋められる。）
         * </p>
         */
        public function safeCall(func:Function, ..._args):* {
            // List for applicable arguments.
            var args:Array = _args;

            // * In AS3, Function.length returns the number of its arguments.
            if (args.length > func.length) {
                args = args.slice(0, func.length);
            }
            else {
                while (args.length < func.length) {
                    args.push(null);
                }
            }

            return func.apply(NaN, args);
        }

        /**
         * Another version of safeCall() using Array arguments instead of
         * variadic parameters.
         */
        public function safeApply(func:Function, args:Array=null):* {
            if (!args) { args = []; }
            var funcAndArgs:Array = [func].concat(args);
            return safeCall.apply(NaN, funcAndArgs);
        }

    }
}
