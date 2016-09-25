package dessert_knife.tools.signal {

    import flash.utils.Dictionary;

    import dessert_knife.knife;

    /**
     * Provides Publish / Subscribe messaging system using Signal.
     */
    public class MessageChannel {

        private var _signals:Dictionary;

        public function MessageChannel() {
            _signals = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function subscribe(message:*, listener:Function):void {
            var signal:Signal = _getSignal(message);
            signal.connect(listener);
        }

        public function subscribeOnce(message:*, listener:Function):void {
            var signal:Signal = _getSignal(message);
            signal.connectOnce(listener);
        }

        public function unsubscribe(message:*, listener:Function):void {
            var signal:Signal = _getSignal(message);
            signal.disconnect(listener);
        }

        public function unsubscribeAll(message:*):void {
            var signal:Signal = _getSignal(message);
            signal.disconnectAll();
        }

        public function publish(message:*, data):void {
            if (!_signals[message]) {
                TART::LOG_WARN {
                    trace("[Warn :: MessageChannel] Message is not subscribed: ", message);
                }
                return;
            }

            var signal:Signal = _getSignal(message);
            signal.emit(data);
        }

        /** Clean up all subscriber of all messages. */
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
