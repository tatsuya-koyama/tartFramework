package actors {

    import flash.geom.Vector3D;
    import flash.utils.getTimer;

    import away3d.containers.View3D;

    import tart.components.KeyInput;
    import tart.core.ActorCore;

    public class CameraController extends ActorCore {

        // To reduce instantiation cost
        private static var _workingVector:Vector3D = new Vector3D();

        private var _keyInput:KeyInput;
        private var _cameraY:Number;

        public override function build():void {
            _keyInput = attach(KeyInput);
        }

        public function CameraController() {}

        public override function awake():void {
            _cameraY = 70;
            tart.graphics.away3DView.camera.y = _cameraY;
        }

        public override function update(deltaTime:Number):void {
            var view:View3D = tart.graphics.away3DView;
            view.camera.x = 350 * Math.cos(getTimer() / 2500);
            view.camera.z = 350 * Math.sin(getTimer() / 2500);

            _moveCameraY(deltaTime);

            var vec:Vector3D = _workingVector;
            vec.x = 0;
            vec.y = 40;
            vec.z = 0;
            view.camera.lookAt(vec);
        }

        private function _moveCameraY(deltaTime:Number):void {
            var keyDirection:Vector3D = _keyInput.getDirection();
            _cameraY -= keyDirection.y * 300 * deltaTime;

            var view:View3D = tart.graphics.away3DView;
            view.camera.y += (_cameraY - view.camera.y) / 20;
        }

    }
}
