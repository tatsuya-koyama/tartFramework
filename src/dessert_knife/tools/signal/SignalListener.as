package dessert_knife.tools.signal {

    public class SignalListener {

        public var handler:Function = null;
        public var once:Boolean     = false;

        public function SignalListener(handler:Function, once:Boolean=false) {
            this.handler = handler;
            this.once    = once;
        }

    }
}
