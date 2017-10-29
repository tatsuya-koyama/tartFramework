package tart.components {

    import tart.core.Component;

    import dessert_knife.tools.signal.Signal;

    /**
     * Component that handles touch events.
     */
    public class Touch2D extends Component {

        public var touchStartSignal:Signal;
        public var touchHoverSignal:Signal;
        public var touchMoveSignal:Signal;
        public var touchEndSignal:Signal;

        public var touchIdToHoldState:Vector.<Boolean>;

        public var offsetX:Number = 0;
        public var offsetY:Number = 0;
        public var width  :Number = 0;
        public var height :Number = 0;

        // ToDo: Circle collision

        public function Touch2D() {
            touchStartSignal = new Signal();
            touchEndSignal   = new Signal();
            touchHoverSignal = new Signal();
            touchMoveSignal  = new Signal();
        }

        public override function getClass():Class {
            return Touch2D;
        }

        public override function onAttach():void {
            touchIdToHoldState = new Vector.<Boolean>(tart.consts.maxFingerNum);
        }

        public override function onDetach():void {
            touchStartSignal.disconnectAll();
            touchHoverSignal.disconnectAll();
            touchMoveSignal .disconnectAll();
            touchEndSignal  .disconnectAll();

            for (var i:int = 0; i < touchIdToHoldState.length; ++i) {
                touchIdToHoldState[i] = false;
            }

            offsetX = 0;
            offsetY = 0;
            width   = 0;
            height  = 0;
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function setHoldState(id:int, isHolding:Boolean):void {
            if (id >= tart.consts.maxFingerNum) {
                return;
            }
            touchIdToHoldState[id] = isHolding;
        }

        public function isHolding(id:int):Boolean {
            if (id >= tart.consts.maxFingerNum) {
                return false;
            }
            return touchIdToHoldState[id];
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

    }
}
