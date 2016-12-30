package actors {

    import flash.events.KeyboardEvent;
    import flash.geom.Vector3D;
    import flash.net.URLRequest;
    import flash.ui.Keyboard;
    import flash.utils.getTimer;

    import away3d.cameras.lenses.OrthographicLens;
    import away3d.containers.View3D;
    import away3d.events.AssetEvent;
    import away3d.library.assets.AssetType;
    import away3d.lights.DirectionalLight;
    import away3d.loaders.Loader3D;
    import away3d.loaders.parsers.Parsers;
    import away3d.materials.TextureMaterial;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.materials.methods.FogMethod;

    import starling.display.Image;

    import tart.components.KeyInput;
    import tart.components.Transform;
    import tart.components.View2D;
    import tart.core.ActorCore;

    public class View3DTester_1 extends ActorCore {

        private var _keyInput:KeyInput;

        public override function build():void {
            compose(Transform, View2D);
            _keyInput = attach(KeyInput);
        }

        public function View3DTester_1() {}

        public override function awake():void {
            //var view:View3D = tart.graphics.away3DView;
            //view.camera.lens = new OrthographicLens();

            Parsers.enableAllBundled();

            var loader:Loader3D = new Loader3D(true, null);
            loader.load(new URLRequest('lab_assets/ruin.awd'));
            loader.scaleX = loader.scaleY = loader.scaleZ = 10.0;

            loader.addEventListener(AssetEvent.ASSET_COMPLETE, _onAssetComplete);

            tart.graphics.away3DView.scene.addChild(loader);
        }

        public override function update(deltaTime:Number):void {
            var view:View3D = tart.graphics.away3DView;
            view.camera.x = 200 *  Math.cos(getTimer() / 1000);
            view.camera.z = 200 *  Math.sin(getTimer() / 1000);
            view.camera.y = 100 * (Math.cos(getTimer() / 3000) + 1.5);
            view.camera.lookAt(new Vector3D(0, 40, 0));
        }

        private function _onAssetComplete(event:AssetEvent):void {
            if (event.asset.assetType != AssetType.MATERIAL) { return; }

            var light:DirectionalLight = _makeLight();
            var lightPicker:StaticLightPicker = new StaticLightPicker([light]);

            var material:TextureMaterial = event.asset as TextureMaterial;
            material.lightPicker = lightPicker;
            material.addMethod(new FogMethod(130, 400, 0xd2d2cc));
        }

        private function _makeLight():DirectionalLight {
            var light:DirectionalLight = new DirectionalLight();
            light.x = 0;
            light.y = 500;
            light.z = 1000;
            light.lookAt(new Vector3D(0, 0, 0));
            light.color    = 0xffffff;
            light.ambient  = 0.5;
            light.diffuse  = 0.8;
            light.specular = 0.3;
            return light;
        }

    }
}
