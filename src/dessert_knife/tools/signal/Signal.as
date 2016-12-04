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
        public function connect(handler:Function, listener:*=null):void {
            var listener:SignalListener = new SignalListener(handler, listener);
            _listeners.push(listener);
        }

        /**
         * Add one-shot event listener.
         * The listener is automatically removed after dispatching event.
         */
        public function connectOnce(handler:Function, listener:*=null):void {
            var listener:SignalListener = new SignalListener(handler, listener, true);
            _listeners.push(listener);
        }

        /** Remove event handler (just remove the first matched handler.) */
        public function disconnect(handler:Function):void {
            for (var i:int = 0; i < _listeners.length; ++i) {
                var listener:SignalListener = _listeners[i];
                if (listener.handler != handler) { continue; }

                listener.dispose();
                _listeners.removeAt(i);
                break;
            }
        }

        /**
         * Remove all event handlers of the given listener.
         * If the given listener is false value, do nothing.
         */
        public function disconnectListener(targetListener:*):void {
            if (!targetListener) { return; }

            for (var i:int = 0; i < _listeners.length; ++i) {
                var listener:SignalListener = _listeners[i];
                if (listener.listener != targetListener) { continue; }

                listener.dispose();
                _listeners.removeAt(i);
                --i;
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
                    listener.dispose();
                    _listeners.removeAt(i);
                    --i;
                }
            }
        }

    }
}
