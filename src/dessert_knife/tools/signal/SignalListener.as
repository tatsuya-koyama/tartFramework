package dessert_knife.tools.signal {

    public class SignalListener {

        public var handler:Function = null;
        public var listener:*       = null;
        public var once:Boolean     = false;

        public function SignalListener(handler:Function, listener:*=null, once:Boolean=false) {
            this.handler  = handler;
            this.listener = listener;
            this.once     = once;
        }

        public function dispose():void {
            handler  = null;
            listener = null;
        }

    }
}
