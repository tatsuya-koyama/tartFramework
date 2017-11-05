package tart.systems {

    import starling.core.Starling;
    import starling.display.Stage;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    import tart.components.Touch2D;
    import tart.core.ActorCore;
    import tart.core.TartContext;
    import tart.core.TartSubSystem;

    public class TouchHandlingSystem extends TartSubSystem {

        private var _touchQueue:Vector.<Touch>;

        public function TouchHandlingSystem() {
            _touchQueue = new Vector.<Touch>;
        }

        public override function get name():String {
            return "TouchHandlingSystem";
        }

        public override function onInit():void {
            _getStarlingStage().addEventListener(TouchEvent.TOUCH, _onTouch);
        }

        public override function onDispose():void {
            _getStarlingStage().removeEventListener(TouchEvent.TOUCH, _onTouch);
            _touchQueue.length = 0;
        }

        public override function process(deltaTime:Number):void {
            for each (var touch:Touch in _touchQueue) {
                _handleTouch(touch);
            }
            _touchQueue.length = 0;
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _getStarlingStage():Stage {
            // ToDo: Fore が無い場合の対応
            return _tartContext.graphics.starlingFore.stage;
        }

        private function _onTouch(event:TouchEvent):void {
            var touches:Vector.<Touch> = event.getTouches(_getStarlingStage(), null);
            for each (var touch:Touch in touches) {
                _touchQueue.push(touch);
            }
        }

        private function _handleTouch(touch:Touch):void {
            if (touch.id >= _tartContext.consts.maxFingerNum) {
                TART::LOG_INFO {
                    trace("[Info :: TouchHandlingSystem] Ignored touch ID : ", touch.id);
                }
                return;
            }

            var actors:Array = _getComponents(ActorCore);
            for each (var actor:ActorCore in actors) {
                if (!actor.isAlive) { continue; }

                var touch2D:Touch2D = actor.getComponent(Touch2D) as Touch2D;
                if (!touch2D) { continue; }

                var isInsideTouch:Boolean = _hitTest(actor, touch, touch2D);
                _emitTouchSignal(touch, touch2D, isInsideTouch);
            }
        }

        private function _hitTest(actor:ActorCore, touch:Touch, touch2D:Touch2D):Boolean {
            var actorX:Number = 0;
            var actorY:Number = 0;
            if (actor.transform) {
                actorX = actor.transform.position.x;
                actorY = actor.transform.position.y;
            }

            var touchX:Number = touch.globalX;
            var touchY:Number = touch.globalY;

            var collisionLeft  :Number = actorX - (touch2D.width / 2) + touch2D.offsetX;
            var collisionRight :Number = collisionLeft + touch2D.width;
            var collisionTop   :Number = actorY - (touch2D.height / 2) + touch2D.offsetY;
            var collisionBottom:Number = collisionTop + touch2D.height;

            if (touchX < collisionLeft  ) { return false; }
            if (touchX > collisionRight ) { return false; }
            if (touchY < collisionTop   ) { return false; }
            if (touchY > collisionBottom) { return false; }

            return true;
        }

        private function _emitTouchSignal(touch:Touch, touch2D:Touch2D, isInsideTouch:Boolean):void {
            var isHolding:Boolean = touch2D.isHolding(touch.id);

            if (isInsideTouch) {
                switch (touch.phase) {
                case TouchPhase.BEGAN:
                    touch2D.touchStartSignal.emit(touch);
                    touch2D.setHoldState(touch.id, true);
                    break;
                case TouchPhase.HOVER:  // * Only for mouse event
                    touch2D.touchHoverSignal.emit(touch);
                    break;
                case TouchPhase.MOVED:
                    touch2D.touchMoveSignal.emit(touch, isHolding);
                }
            }

            if (isHolding) {
                switch (touch.phase) {
                case TouchPhase.MOVED:
                    touch2D.touchMoveSignal.emit(touch, isHolding);
                    break;
                // Touch End events are dispatched only if touch is started inside of touch collision.
                case TouchPhase.ENDED:
                    touch2D.touchEndSignal.emit(touch, isInsideTouch);
                    touch2D.setHoldState(touch.id, false);
                    break;
                }
            }
        }

    }
}
