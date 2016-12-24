package tart.components {

    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;

    import tart.core.Component;

    import dessert_knife.knife;
    import dessert_knife.tools.signal.Signal;

    /**
     * Component that handles keyboard events.
     */
    public class KeyInput extends Component {

        // To reduce instantiation cost
        private static var _workingVector:Vector3D = new Vector3D();

        public function KeyInput() {}

        public override function getClass():Class {
            return KeyInput;
        }

        public override function onAttach():void {

        }

        public override function onDetach():void {
            tart.keyboard.keyDownSignal.disconnectListener(this);
            tart.keyboard.keyUpSignal  .disconnectListener(this);
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        // ToDo: キーストローク対応

        public function isPressed(keyCode:int):Boolean {
            return tart.keyboard.isPressed(keyCode);
        }

        /**
         * Returns direction of pressed arrow keys as Vector3D.
         *
         * <p>Example:</p>
         * <ul>
         *   <li>If only RIGHT key is pressed, returns [1.0, 0, 0] vector.</li>
         *   <li>If RIGHT and LEFT pressed, returns [0, 0, 0].</li>
         *   <li>
         *     If RIGHT and UP pressed, returns [0.707, -0.707, 0].
         *     (If <code>normalize</code> is set to false, returns [1.0, -1.0, 0].)
         *   </li>
         * </ul>
         */
        public function getDirection(normalize:Boolean=true):Vector3D {
            var vec:Vector3D = _workingVector;
            vec.x = 0;
            vec.y = 0;

            if (tart.keyboard.isPressed(Keyboard.LEFT )) { vec.x -= 1.0; }
            if (tart.keyboard.isPressed(Keyboard.RIGHT)) { vec.x += 1.0; }
            if (tart.keyboard.isPressed(Keyboard.UP   )) { vec.y -= 1.0; }
            if (tart.keyboard.isPressed(Keyboard.DOWN )) { vec.y += 1.0; }

            if (normalize) { vec.normalize(); }
            return vec;
        }

        /** Add event handler for key down event. */
        public function onKeyDown(handler:Function):void {
            tart.keyboard.keyDownSignal.connect(handler, this);
        }

        /** Add event handler for key up event. */
        public function onKeyUp(handler:Function):void {
            tart.keyboard.keyUpSignal.connect(handler, this);
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

    }
}
