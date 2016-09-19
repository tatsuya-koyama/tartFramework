package dessert_knife.tools.async {

    import dessert_knife.knife;

    /**
     * Simple, light-weight deferred utility.
     * It has only poor features, but fast and low memory consumption.
     *
     * <p>Usage:</p>
     * <listing>
     *      // Make sure async function returns Defer object itself.
     *      function asyncTask():Defer {
     *          var defer:Defer = new Defer();
     *          // do some async task
     *          setTimeout(function():void {
     *              defer.done("HOGE");
     *          }, 0);
     *          return defer;
     *      }
     * 
     *      // How to write async sequence:
     *      asyncTask()
     *          .then(nextTask)
     *          .then(finalTask);
     * 
     *      // * Result value is passed to next task:
     *      asyncTask()
     *          .then(function(result:String):String {
     *              trace(result);  // -> HOGE
     *              return result + "_FUGA";
     *          })
     * 
     *          .then(function(result:String):void {
     *              trace(result);  // -> HOGE_FUGA
     *          })
     * 
     *          // Deferred task can be used in then() chain.
     *          .then(function(result:String):Defer {
     *              var defer:Defer = new Defer();
     *              setTimeout(function():void {
     *                  defer.done(result + "_PIYO");
     *              }, 0);
     *              return defer;
     *          })
     * 
     *          .then(function(result:String):void {
     *              trace(result);  // -> HOGE_FUGA_PIYO
     *          });
     * </listing>
     *
     * <p>Note:</p>
     * <ul>
     *   <li>Error handling feature (reject method or try-catch) NOT provided!
     *       Use orthodox Promise if you need it.</li>
     *   <li>Unlike Promise, then() does NOT make new Defer instance
     *       to save the memory.</li>
     * </ul>
     */
    public class Defer {

        private var _pendingTasks:Vector.<Function>;
        private var _isResolved:Boolean;
        private var _value:*;

        public function Defer() {
            _pendingTasks = new Vector.<Function>();
            _isResolved   = false;
            _value        = null;
        }

        public function done(result:*=null):Defer {
            _value      = result;
            _isResolved = true;
            return _handlePending();
        }

        /** Syntax sugar of making callback to call done(result). */
        public function ender(result:*=null):Function {
            return function():void {
                done(result);
            }
        }

        public function then(task:Function):Defer {
            if (_isResolved) {
                return _handle(task);
            }

            _pendingTasks.push(task);
            return this;
        }

        private function _handle(task:Function):Defer {
            var result:* = knife.func.safeCall(task, _value);
            if (result is Defer) {
                _isResolved = false;
                result.then(function(result2:*):void {
                    done(result2);
                });
                return this;
            }

            _value = result;
            return _handlePending();
        }

        private function _handlePending():Defer {
            if (!_pendingTasks.length) { return this; }

            var nextTask:Function = _pendingTasks.shift();
            return _handle(nextTask);
        }

    }

}
