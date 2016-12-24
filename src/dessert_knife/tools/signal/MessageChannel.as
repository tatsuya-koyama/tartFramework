package dessert_knife.tools.signal {

    import flash.utils.Dictionary;

    import dessert_knife.knife;

    /**
     * Provides Publish / Subscribe messaging system using Signal.
     * MessageChannel holds Signal instances of each message.
     */
    public class MessageChannel {

        private var _signals:Dictionary;  // {<message:*> : <Signal>}

        public function MessageChannel() {
            _signals = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function subscribe(message:*, handler:Function, listener:*=null):void {
            var signal:Signal = _getSignal(message);
            signal.connect(handler, listener);
        }

        public function subscribeOnce(message:*, handler:Function, listener:*=null):void {
            var signal:Signal = _getSignal(message);
            signal.connectOnce(handler, listener);
        }

        public function unsubscribe(message:*, handler:Function):void {
            var signal:Signal = _getSignal(message);
            signal.disconnect(handler);
        }

        public function unsubscribeListener(message:*, listener:*):void {
            var signal:Signal = _getSignal(message);
            signal.disconnectListener(listener);
        }

        public function unsubscribeAll(message:*):void {
            var signal:Signal = _getSignal(message);
            signal.disconnectAll();
        }

        public function publish(message:*, data:*=null):void {
            if (!_signals[message]) {
                TART::LOG_WARN {
                    trace("[Warn :: MessageChannel] Message is not subscribed: ", message);
                }
                return;
            }

            var signal:Signal = _getSignal(message);
            signal.emit(data);
        }

        /** Clean up all subscribers of each message. */
        public function reset():void {
            for (var message:* in _signals) {
                var signal:Signal = _signals[message];
                signal.disconnectAll();
                delete _signals[message];
            }
        }

        public function dispose():void {
            reset();
            _signals = null;
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        /**
         * Returns Signal object corresponding to message.
         * [Note] If the Signal does not exist yet, this method creates new Signal.
         */
        private function _getSignal(message:*):Signal {
            if (!_signals[message]) {
                _signals[message] = new Signal();
            }

            return _signals[message];
        }

    }
}
