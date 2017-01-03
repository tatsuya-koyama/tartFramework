package tart.components {

    import flash.utils.ByteArray;

    import away3d.containers.ObjectContainer3D;
    import away3d.loaders.Loader3D;
    import away3d.loaders.parsers.AWDParser;

    import tart.core.Component;

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

        public function makeMeshFromAwd(awdName:String):Loader3D
        {
            var awdData:ByteArray = tart.resource.getAwd(awdName);
            var obj3d:Loader3D = new Loader3D(false, null);
            obj3d.loadData(awdData, null, null, new AWDParser());
            tart.graphics.away3DView.scene.addChild(obj3d);

            this.displayObjContainer = obj3d;
            return obj3d;
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

    }
}
