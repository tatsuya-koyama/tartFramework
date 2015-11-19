package dessert_knife {

    import dessert_knife.tools.Await;

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
        // utilities
        //----------------------------------------------------------------------

        /**
         * Wait one or more asynchronous tasks.
         * In <code>kicker</code> function, you can call <code>await.it()</code>
         * as a callback of tasks. When all tasks' callbacks are called,
         * <code>onAllComplete</code> will be called.
         *
         * <p>Example:</p>
         * <pre>
         *     import dessert_knife.knife;
         *     import dessert_knife.tools.Await;
         *     ...
         *     knife.await(
         *         function(await:Await):void {
         *             someAsyncTask_1(await.it());  // * Argument is onComplete handler
         *             someAsyncTask_2(await.it());
         *             someAsyncTask_3(await.it());
         *             ...
         *         },
         *         function():void {
         *             trace("All is done.");
         *         }
         *     );
         * </pre>
         */
        public function await(kicker:Function, onAllComplete:Function):void {
            Await.doit(kicker, onAllComplete);
        }

    }
}
