package dessert_knife.tools.async {

    /**
     * Another way to handle Promise object.
     *
     * <p>Usage:</p>
     * <listing>
     *     function asyncTask():Promise {
     *         var deferred:Deferred = new Deferred();
     *         setTimeout(function():void {
     *             if (TASK_IS_SUCCEEDED) {
     *                 deferred.done();
     *             } else {
     *                 deferred.fail();
     *             }
     *         }, 0);
     *         return deferred.promise;
     *     }
     * 
     *     asyncTask().then(nextTask);
     * </listing>
     *
     * @see dessert_knife.tools.async.Promise
     */
    public class Deferred {

        private var _promise:Promise;
        private var _resolve:Function;
        private var _reject :Function;

        public function Deferred(throwException:Boolean=false, ensureAsync:Boolean=true) {
            _promise = new Promise(function(resolve:Function, reject:Function):void {
                _resolve = resolve;
                _reject  = reject;
            }, throwException, ensureAsync);
        }

        public function get promise():Promise {
            return _promise;
        }

        public function done(result:*):Deferred {
            _resolve(result);
            return this;
        }

        public function fail(error:*):Deferred {
            _reject(error);
            return this;
        }

    }

}
