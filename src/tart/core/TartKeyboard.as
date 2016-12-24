package tart.core {

    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;

    import dessert_knife.knife;
    import dessert_knife.tools.signal.Signal;

    /**
     * Facade of Keyboard events.
     */
    public class TartKeyboard {

        public var keyDownSignal:Signal;
        public var keyUpSignal  :Signal;

        private var _stage:Stage;
        private var _keyStates:Dictionary;  // {<keyCode:int> : <isPressed:Boolean>}

        public function TartKeyboard() {
            keyDownSignal = new Signal();
            keyUpSignal   = new Signal();

            _keyStates = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function init(stage:Stage):void {
            _stage = stage;
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
            _stage.addEventListener(KeyboardEvent.KEY_UP,   _onKeyUp);
        }

        public function dispose():void {
            if (_stage) {
                _stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
                _stage.removeEventListener(KeyboardEvent.KEY_UP,   _onKeyUp);
            }
            knife.map.clear(_keyStates);
        }

        public function isPressed(keyCode:int):Boolean {
            return _keyStates[keyCode];
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _onKeyDown(event:KeyboardEvent):void {
            if (_keyStates[event.keyCode]) { return; }

            _keyStates[event.keyCode] = true;
            keyDownSignal.emit(event);
        }

        private function _onKeyUp(event:KeyboardEvent):void {
            _keyStates[event.keyCode] = false;
            keyUpSignal.emit(event);
        }

    }
}
