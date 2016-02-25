package dessert_knife.tools {

    /**
     * Another way to handle Promise object.
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

        public function done(result:*):void {
            _resolve(result);
        }

        public function fail(error:*):void {
            _reject(error);
        }

    }

}
