package dessert_knife.tools {

    import flash.utils.setTimeout;

    /**
     * Simple Promise implementation for AS3.
     *
     * <p>Usage:</p>
     * <listing>
     *     // Make sure async function returns Promise.
     *     function asyncTask_1():Promise {
     *         return new Promise(function(resolve:Function, reject:Function):void {
     *             setTimeout(function():void {
     *                 if (TASK_IS_SUCCEEDED) {
     *                     resolve(RESULT);
     *                 } else {
     *                     reject(REASON);
     *                 }
     *             }, 0);
     *         });
     *     }
     * 
     *     // How to write async sequence and error handling:
     *     asyncTask_1()
     *         .then(asyncTask_2)
     *         .then(asyncTask_3)
     *         .otherwise(onErrorOf_1_or_2_or_3)  // Same as cacth() of Promise in ECMAScript6
     *         .then(function(result_1_to_3:*):void {
     *             var result_4 = result_1_to_3 + 1;
     *             return result_4;
     *         })
     *         .then(function(result_4:*):void { ... })
     *         .otherwise(function(errorObject:*):void { ... });
     * </listing>
     */
    public class Promise {

        private const PENDING   :uint = 1;
        private const FULFILLED :uint = 2;
        private const REJECTED  :uint = 3;

        private var _state:uint = PENDING;
        private var _value:*    = null;
        private var _handlers:Vector.<Handler> = new Vector.<Handler>();

        // options
        private var _throwException:Boolean = false;
        private var _ensureAsync:Boolean    = true;

        //----------------------------------------------------------------------
        // public methods
        //----------------------------------------------------------------------

        /**
         * Returns new Promise object.
         * @param throwException - If true, throws Error when exception is caught.
         *                         It's handy for unit testing.
         * @param ensureAsync - If true, tasks of then() are surely invoked in next frame.
         */
        public function Promise(task:Function, throwException:Boolean=false, ensureAsync:Boolean=true) {
            _throwException = throwException;
            _ensureAsync    = ensureAsync;

            _kickoff(task);
        }

        public function then(onFulfilled:Function=null, onRejected:Function=null):Promise {
            return new Promise(function(resolve:Function, reject:Function):void {
                _doHandle(
                    // onFulfilled
                    function(result:*):* {
                        if (onFulfilled == null) {
                            return resolve(result);
                        }
                        return resolve(onFulfilled(result));
                    },
                    // onRejected
                    function(error:*):* {
                        if (onRejected == null) {
                            return reject(error);
                        }
                        return resolve(onRejected(error));
                    }
                );
            }, _throwException, _ensureAsync);
        }

        //----------------------------------------------------------------------
        // syntax sugars
        //----------------------------------------------------------------------

        /**
         * Same as cacth() of Promise in ECMAScript6.
         * (Reserved word 'catch' cannot be used for identifier in AS3.)
         */
        public function otherwise(onRejected:Function):Promise {
            return then(null, onRejected);
        }

        public static function resolve(result:*,
                                       throwException:Boolean=false,
                                       ensureAsync:Boolean=true):Promise
        {
            return new Promise(function(resolve:Function, reject:Function):void {
                resolve(result);
            }, throwException, ensureAsync);
        }

        public static function reject(error:*,
                                      throwException:Boolean=false,
                                      ensureAsync:Boolean=true):Promise
        {
            return new Promise(function(resolve:Function, reject:Function):void {
                reject(error);
            }, throwException, ensureAsync);
        }

        //----------------------------------------------------------------------
        // state transition
        //----------------------------------------------------------------------

        private function _resolve(result:*):void {
            try {
                if (result is Promise) {
                    _kickoff(result.then);
                    return;
                }
                _fulfill(result);
            } catch (ex:Error) {
                _handleException(ex);
            }
        }

        private function _reject(error:*):void {
            _state = REJECTED;
            _value = error;
            for each (var handler:Handler in _handlers) {
                _handle(handler);
            }
            _handlers = null;
        }

        private function _fulfill(result:*):void {
            _state = FULFILLED;
            _value = result;
            for each (var handler:Handler in _handlers) {
                _handle(handler);
            }
            _handlers = null;
        }

        //----------------------------------------------------------------------
        // private jobs
        //----------------------------------------------------------------------

        private function _kickoff(task:Function):void {
            var isAlreadyDone:Boolean = false;
            try {
                task(
                    // resolver
                    function(result:*):void {
                        if (isAlreadyDone) { return; }
                        isAlreadyDone = true;
                        _resolve(result);
                    },
                    // rejector
                    function(error:*):void {
                        if (isAlreadyDone) { return; }
                        isAlreadyDone = true;
                        _reject(error);
                    }
                );
            } catch (ex:Error) {
                if (isAlreadyDone) { return; }
                isAlreadyDone = true;
                _handleException(ex);
            }
        }

        private function _handleException(ex:Error):void {
            if (_throwException) { throw ex; }
            _reject(ex);
        }

        private function _doHandle(onFulfilled:Function, onRejected:Function):void {
            // If option is true, ensure invoking then() is always asynchronous.
            if (_ensureAsync) {
                setTimeout(function():void {
                    _handle(new Handler(onFulfilled, onRejected));
                }, 0);
                return;
            }

            _handle(new Handler(onFulfilled, onRejected));
        }

        private function _handle(handler:Handler):void {
            if (_state == PENDING) {
                _handlers.push(handler);
                return;
            }
            if (_state == FULFILLED && handler.onFulfilled != null) {
                handler.onFulfilled(_value);
                return;
            }
            if (_state == REJECTED && handler.onRejected != null) {
                handler.onRejected(_value);
                return;
            }
        }

    }
}

class Handler {

    public var onFulfilled:Function;
    public var onRejected:Function;

    public function Handler(onFulfilled:Function=null, onRejected:Function=null) {
        this.onFulfilled = onFulfilled;
        this.onRejected  = onRejected;
    }

}
