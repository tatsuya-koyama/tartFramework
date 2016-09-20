package dessert_knife.tools.signal {

    import dessert_knife.knife;

    /**
     * Mini dispatcher for simple event system.
     */
    public class Signal {

        private var _listeners:Vector.<SignalListener>;

        public function Signal() {
            _listeners = new Vector.<SignalListener>();
        }

        public function numListeners():int {
            return _listeners.length;
        }

        /** Add event listener. */
        public function connect(handler:Function):void {
            var listener:SignalListener = new SignalListener(handler);
            _listeners.push(listener);
        }

        /**
         * Add one-shot event listener.
         * The listener is automatically removed after dispatching event.
         */
        public function connectOnce(handler:Function):void {
            var listener:SignalListener = new SignalListener(handler, true);
            _listeners.push(listener);
        }

        /** Remove event listener. */
        public function disconnect(handler:Function):void {
            for (var i:int = 0; i < _listeners.length; ++i) {
                var listener:SignalListener = _listeners[i];
                if (listener.handler != handler) { continue; }

                _listeners.removeAt(i);
                break;
            }
        }

        /** Remove all event listeners. */
        public function disconnectAll():void {
            _listeners.length = 0;
        }

        /** Dispatch event. */
        public function emit(...eventArgs):void {
            for (var i:int = 0; i < _listeners.length; ++i) {
                var listener:SignalListener = _listeners[i];
                knife.func.safeApply(listener.handler, eventArgs);

                if (listener.once) {
                    _listeners.removeAt(i);
                    --i;
                }
            }
        }

    }
}
