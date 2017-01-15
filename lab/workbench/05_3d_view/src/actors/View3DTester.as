package actors {

    import flash.display.BlendMode;
    import flash.geom.Vector3D;
    import flash.utils.ByteArray;

    import tart.components.Transform;
    import tart.components.View3D;
    import tart.core.ActorCore;

    import dessert_knife.knife;

    public class View3DTester extends ActorCore {

        private var _lifeTime:Number;
        private var _passedTime:Number;

        public override function build():void {
            compose(Transform, View3D);
        }

        public function View3DTester() {
            _lifeTime   = knife.rand.float(3.0, 20.0);
            _passedTime = 0;
        }

        public override function awake():void {
            _view3D.makeMeshFromAwd('ruin');
            // _view3D.makeMeshFromObj('ruin');
            // _view3D.makeMeshFrom3ds('ruin');

            _transform.position.x = knife.rand.float(-180, 180);
            _transform.position.y = knife.rand.float(-300, 130);
            _transform.position.z = knife.rand.float(-180, 180);
            _transform.rotation.y = knife.rand.integer(8) * 45;
            _transform.scale.setTo(0, 0, 0);
        }

        public override function update(deltaTime:Number):void {
            _lifeTime   -= deltaTime;
            _passedTime += deltaTime;

            if (_lifeTime <= 0) {
                destroy();
                return;
            }

            _appearEffect(_passedTime);
            _disappearEffect(_lifeTime);
        }

        private function _appearEffect(passedTime:Number):void {
            if (passedTime > 0.5) { return; }

            var ratio:Number = passedTime / 0.5;
            var scale:Number = ratio * ratio * 4.0;
            _transform.scale.setTo(scale, scale, scale);
        }

        private function _disappearEffect(lifeTime:Number):void {
            if (lifeTime > 0.5) { return; }

            var ratio:Number = lifeTime / 0.5;
            var scale:Number = ratio * ratio * 4.0;
            _transform.scale.setTo(scale, scale, scale);
        }

    }
}
