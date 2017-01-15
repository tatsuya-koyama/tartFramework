package tart.components {

    import flash.utils.ByteArray;

    import away3d.containers.ObjectContainer3D;
    import away3d.entities.Mesh;
    import away3d.loaders.Loader3D;
    import away3d.loaders.parsers.AWDParser;
    import away3d.loaders.parsers.Max3DSParser;

    import tart.core.Component;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    /**
     * 3D view component powered by Away3D.
     */
    public class View3D extends Component {

        public var displayObjContainer:ObjectContainer3D;

        public override function getClass():Class {
            return View3D;
        }

        public override function onDetach():void {
            if (displayObjContainer) {
                displayObjContainer.dispose();
                displayObjContainer = null;
            }
        }

        //----------------------------------------------------------------------
        // helper methods
        //----------------------------------------------------------------------

        public function makeMeshFromAwd(awdName:String):Mesh {
            var loader3d:Loader3D = tart.resource.getAwd(awdName);
            return _cloneMesh(loader3d);
        }

        public function makeMeshFromObj(objName:String):Mesh {
            var loader3d:Loader3D = tart.resource.getObj(objName);
            return _cloneMesh(loader3d);
        }

        public function makeMeshFrom3ds(max3dsName:String):Mesh {
            var loader3d:Loader3D = tart.resource.get3ds(max3dsName);
            return _cloneMesh(loader3d);
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _cloneMesh(src3d:Loader3D):Mesh {
            var loadedMesh:Mesh = Mesh(src3d.getChildAt(0));
            var mesh:Mesh = new Mesh(loadedMesh.geometry, loadedMesh.material);
            tart.graphics.away3DView.scene.addChild(mesh);
            this.displayObjContainer = mesh;
            return mesh;
        }

    }
}
