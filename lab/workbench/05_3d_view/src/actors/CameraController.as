package actors {

    import flash.geom.Vector3D;
    import flash.utils.getTimer;

    import away3d.containers.View3D;

    import tart.core.ActorCore;

    public class CameraController extends ActorCore {

        // To reduce instantiation cost
        private static var _workingVector:Vector3D = new Vector3D();

        public override function build():void {}

        public function CameraController() {}

        public override function awake():void {}

        public override function update(deltaTime:Number):void {
            var view:View3D = tart.graphics.away3DView;
            view.camera.x = 300 *  Math.cos(getTimer() / 1000);
            view.camera.z = 300 *  Math.sin(getTimer() / 1000);
            view.camera.y = 100 * (Math.cos(getTimer() / 3000) + 1.5);

            var vec:Vector3D = _workingVector;
            vec.x = 0;
            vec.y = 40;
            vec.z = 0;
            view.camera.lookAt(vec);
        }

    }
}
