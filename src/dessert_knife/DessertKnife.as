package dessert_knife {

    import dessert_knife.blades.RandomKnife;
    import dessert_knife.tools.async.Async;
    import dessert_knife.tools.async.Await;

    public class DessertKnife {

        //----------------------------------------------------------------------
        // Instant accessor
        //----------------------------------------------------------------------

        private static var _instance:DessertKnife;

        public static function get instance():DessertKnife {
            if (!_instance) {
                _instance = new DessertKnife();
            }
            return _instance;
        }

        //----------------------------------------------------------------------
        // Top level utilities
        //----------------------------------------------------------------------

        /**
         * Handles complicated (parallel-sequential mixed) asynchronous tasks.
         *
         * <p>Example:</p>
         * <listing>
         *     import dessert_knife.knife;
         *     import dessert_knife.tools.async.Async;
         * 
         *     knife.async({
         *         serial   : [function(async:Async):void { ... }, ...],
         *         // OR
         *         parallel : [function(async:Async):void { ... }, ...],
         * 
         *         // *** optional ***
         *         success  : function():void { ... },
         *         error    : function():void { ... },
         *         anyway   : function():void { ... }
         *     }, onComplete);
         * </listing>
         *
         * @see dessert_knife.tools.async.Async
         */
        public function async(asyncDef:*, onComplete:Function=null):void {
            var async:Async = new Async(asyncDef);
            async.go(onComplete);
        }

        /**
         * Waits for one or more asynchronous tasks.
         * In <code>kicker</code> function, you can call <code>await.it()</code>
         * as a callback of tasks. When all tasks' callbacks are called,
         * <code>onAllComplete</code> will be called.
         *
         * <p>Example:</p>
         * <listing>
         *     import dessert_knife.knife;
         *     import dessert_knife.tools.async.Await;
         * 
         *     knife.await(
         *         function(await:Await):void {
         *             someAsyncTask_1(await.it());  // * Argument is callback
         *             someAsyncTask_2(await.it());
         *             someAsyncTask_3(await.it());
         *             ...
         *         },
         *         function():void {
         *             trace("All is done.");
         *         }
         *     );
         * </listing>
         */
        public function await(kicker:Function, onAllComplete:Function):void {
            Await.doit(kicker, onAllComplete);
        }

        //----------------------------------------------------------------------
        // 2nd level utilities
        //----------------------------------------------------------------------

        /**
         * Returns instance of RandomKnife.
         * @see dessert_knife.blades.RandomKnife
         */
        public function get rand():RandomKnife {
            return RandomKnife.instance;
        }

    }
}
