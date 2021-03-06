package tart.components {

    import flash.geom.Vector3D;

    import tart.core.Component;

    public class Transform extends Component {

        public var position:Vector3D;
        public var scale   :Vector3D;
        public var rotation:Vector3D;

        public function Transform() {
            position = new Vector3D(0, 0, 0);
            scale    = new Vector3D(1, 1, 1);
            rotation = new Vector3D(0, 0, 0);
        }

        public override function getClass():Class {
            return Transform;
        }

        public override function onDetach():void {
            position.setTo(0, 0, 0);
            scale   .setTo(1, 1, 1);
            rotation.setTo(0, 0, 0);
        }

    }
}
