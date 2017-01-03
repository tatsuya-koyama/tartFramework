package actors {

    import flash.display.BlendMode;
    import flash.geom.Vector3D;
    import flash.utils.ByteArray;

    import away3d.events.AssetEvent;
    import away3d.library.assets.AssetType;
    import away3d.lights.DirectionalLight;
    import away3d.loaders.Loader3D;
    import away3d.loaders.parsers.AWDParser;
    import away3d.loaders.parsers.Parsers;
    import away3d.materials.TextureMaterial;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.materials.methods.FogMethod;

    import tart.components.Transform;
    import tart.components.View3D;
    import tart.core.ActorCore;

    import dessert_knife.knife;

    public class View3DTester_2 extends ActorCore {

        private var _obj3d:Loader3D;
        private var _lifeTime:Number;

        public override function build():void {
            compose(Transform, View3D);
        }

        public function View3DTester_2() {
            _lifeTime = knife.rand.float(3.0, 10.0);
        }

        public override function awake():void {
            _view3D.makeMeshFromAwd('ruin');
            _view3D.displayObjContainer.addEventListener(AssetEvent.ASSET_COMPLETE, _onAssetComplete);

            _transform.position.x = knife.rand.float(-100, 100);
            _transform.position.y = knife.rand.float(-100, 100);
            _transform.position.z = knife.rand.float(-100, 100);
            _transform.rotation.y = knife.rand.integer(8) * 45;
            _transform.scale.setTo(4.0, 4.0, 4.0);
        }

        public override function update(deltaTime:Number):void {
            _lifeTime -= deltaTime;
            if (_lifeTime <= 0) {
                destroy();
            }
        }

        private function _onAssetComplete(event:AssetEvent):void {
            if (event.asset.assetType != AssetType.MATERIAL) { return; }

            var light:DirectionalLight = _makeLight();
            var lightPicker:StaticLightPicker = new StaticLightPicker([light]);

            var material:TextureMaterial = event.asset as TextureMaterial;
            material.lightPicker = lightPicker;
            material.addMethod(new FogMethod(250, 600, 0xd2d2cc));

            //material.alphaBlending = true;
            //material.alphaPremultiplied = false;
            //material.blendMode = BlendMode.MULTIPLY;
        }

        private function _makeLight():DirectionalLight {
            var light:DirectionalLight = new DirectionalLight();
            light.x = 0;
            light.y = 500;
            light.z = 1000;
            light.lookAt(new Vector3D(0, 0, 0));
            light.color    = 0xffccaa;
            light.ambient  = 0.5;
            light.diffuse  = 0.8;
            light.specular = 0.3;
            return light;
        }

    }
}
