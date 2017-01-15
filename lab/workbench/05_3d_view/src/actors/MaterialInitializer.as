package actors {

    import flash.geom.Vector3D;

    import away3d.entities.Mesh;
    import away3d.lights.DirectionalLight;
    import away3d.materials.TextureMaterial;
    import away3d.materials.ColorMaterial;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.materials.methods.FogMethod;
    import away3d.materials.methods.OutlineMethod;
    import away3d.materials.methods.RimLightMethod;

    import tart.core.ActorCore;

    public class MaterialInitializer extends ActorCore {

        private var _elapsedTime:Number = 0;

        public override function build():void {}

        public function MaterialInitializer() {}

        public override function awake():void {
            var ruin:Mesh = tart.resource.getAwdMesh('ruin');
            // var ruin:Mesh = tart.resource.getObjMesh('ruin');
            // var ruin:Mesh = tart.resource.get3dsMesh('ruin');

            var light:DirectionalLight = _makeDirectionalLight();
            var lightPicker:StaticLightPicker = new StaticLightPicker([light]);

            var material:TextureMaterial = ruin.material as TextureMaterial;
            // var material:ColorMaterial = ruin.material as ColorMaterial;

            material.lightPicker = lightPicker;
            material.addMethod(new FogMethod(250, 600, 0xd2d2cc));
            material.addMethod(new OutlineMethod(0x442211, 0.1, false, false));
            // material.addMethod(new RimLightMethod(0xffff88, 40, 40));
        }

        private function _makeDirectionalLight():DirectionalLight {
            var light:DirectionalLight = new DirectionalLight();
            light.x = 0;
            light.y = 500;
            light.z = 1000;
            light.lookAt(new Vector3D(0, 0, 0));
            light.color        = 0xffccaa;
            light.ambient      = 0.45;
            light.ambientColor = 0xddeeff;
            light.diffuse      = 0.8;
            light.specular     = 0.8;
            return light;
        }

    }
}
