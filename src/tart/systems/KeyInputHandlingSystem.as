package tart.systems {

    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;

    import tart.components.KeyInput;
    import tart.core.ActorCore;
    import tart.core.TartContext;
    import tart.core.TartSubSystem;

    import dessert_knife.knife;

    public class KeyInputHandlingSystem extends TartSubSystem {

        private var _keyEventQueue:Vector.<KeyboardEvent>;
        private var _keyStates:Dictionary;  // {<keyCode:int> : <isPressed:Boolean>}

        public function KeyInputHandlingSystem() {
            _keyEventQueue = new Vector.<KeyboardEvent>;
            _keyStates     = new Dictionary();
        }

        public override function get name():String {
            return "KeyInputHandlingSystem";
        }

        public override function onInit():void {
            var stage:Stage = _tartContext.graphics.stage;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
        }

        public override function onDispose():void {
            var stage:Stage = _tartContext.graphics.stage;
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);

            _keyEventQueue.length = 0;
            knife.map.clear(_keyStates);
        }

        public override function process(deltaTime:Number):void {
            for each (var keyEvent:KeyboardEvent in _keyEventQueue) {
                _handleKeyInput(keyEvent);
            }
            _keyEventQueue.length = 0;
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _onKeyDown(event:KeyboardEvent):void {
            // Ignore native key stroke events.
            if (_keyStates[event.keyCode]) { return; }

            _keyStates[event.keyCode] = true;
            _keyEventQueue.push(event);
        }

        private function _onKeyUp(event:KeyboardEvent):void {
            _keyStates[event.keyCode] = false;
            _keyEventQueue.push(event);
        }

        // ToDo: キーストローク対応
        private function _handleKeyInput(event:KeyboardEvent):void {
            var actors:Array = _getComponents(ActorCore);
            for each (var actor:ActorCore in actors) {
                if (!actor.isAlive) { continue; }

                var keyInput:KeyInput = actor.getComponent(KeyInput) as KeyInput;
                if (!keyInput) { continue; }

                keyInput.keyStates = _keyStates;
                _emitKeySignal(event, keyInput);
            }
        }

        private function _emitKeySignal(event:KeyboardEvent, keyInput:KeyInput):void {
            switch (event.type) {
            case KeyboardEvent.KEY_DOWN:
                keyInput.keyDownSignal.emit(event);
                break;
            case KeyboardEvent.KEY_UP:
                keyInput.keyUpSignal.emit(event);
                break;
            }
        }

    }
}
