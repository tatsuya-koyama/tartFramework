package dessert_knife.tools.async {

    public class Await {

        private var _onAllComplete:Function;
        private var _callbackCount:int = 0;
        private var _callbackTotal:int = 0;

        public static function doit(kicker:Function, onAllComplete:Function):void {
            var await:Await = new Await();
            await.go(
                function():void { kicker(await); },
                onAllComplete
            );
        }

        public function go(kicker:Function, onAllComplete:Function):void {
            _onAllComplete = onAllComplete;
            it(kicker)();
        }

        public function it(callback:Function=null):Function {
            ++_callbackTotal;

            return function(... args):void {
                if (callback != null) {
                    callback.apply(callback, args);
                }
                ++_callbackCount;

                // check if all is done
                if (_callbackCount == _callbackTotal) {
                    if (_onAllComplete != null) {
                        _onAllComplete();
                    }
                    _onAllComplete = null;
                }
            };
        }

    }
}
