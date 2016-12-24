package dessert_knife {

    import dessert_knife.blades.FunctionKnife;
    import dessert_knife.blades.ListKnife;
    import dessert_knife.blades.MapKnife;
    import dessert_knife.blades.RandomKnife;
    import dessert_knife.blades.StringKnife;
    import dessert_knife.tools.async.Async;
    import dessert_knife.tools.async.Await;
    import dessert_knife.tools.async.Defer;
    import dessert_knife.tools.async.Deferred;
    import dessert_knife.tools.async.Promise;

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

        /**
         * Returns promise object.
         * By default, its option ensureAsync is false for performance reasons.
         * @see dessert_knife.tools.async.Promise
         */
        public function promise(task:Function, throwException:Boolean=false,
                                ensureAsync:Boolean=false):Promise
        {
            return new Promise(task, throwException, ensureAsync);
        }

        /**
         * Returns wrapped-promise object.
         * By default, its option ensureAsync is false for performance reasons.
         * @see dessert_knife.tools.async.Deferred
         */
        public function deferred(throwException:Boolean=false,
                                 ensureAsync:Boolean=false):Deferred
        {
            return new Deferred(throwException, ensureAsync);
        }

        /**
         * Returns light-weight Promise-like object.
         * Features are limited, but very fast and low memory consumption.
         * If all you want to do is refining codes of callback chain,
         * Defer will be a good solution.
         * @see dessert_knife.tools.async.Defer
         */
        public function defer():Defer {
            return new Defer();
        }

        //----------------------------------------------------------------------
        // 2nd level utilities
        //----------------------------------------------------------------------

        /**
         * Returns singleton instance of RandomKnife.
         * @see dessert_knife.blades.RandomKnife
         */
        public function get rand():RandomKnife {
            return RandomKnife.instance;
        }

        /**
         * Returns singleton instance of ListKnife.
         * @see dessert_knife.blades.ListKnife
         */
        public function get list():ListKnife {
            return ListKnife.instance;
        }

        /**
         * Returns singleton instance of MapKnife.
         * @see dessert_knife.blades.MapKnife
         */
        public function get map():MapKnife {
            return MapKnife.instance;
        }

        /**
         * Returns singleton instance of StringKnife.
         * @see dessert_knife.blades.StringKnife
         */
        public function get str():StringKnife {
            return StringKnife.instance;
        }

        /**
         * Returns singleton instance of FunctionKnife.
         * @see dessert_knife.blades.FunctionKnife
         */
        public function get func():FunctionKnife {
            return FunctionKnife.instance;
        }

    }
}
