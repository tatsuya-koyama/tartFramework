package tart.actors {

    import starling.core.Starling;
    import starling.display.Sprite;

    import tart.components.View2D;
    import tart.core.tart_internal;
    import tart.core.ISceneScope;
    import tart.core.ILayer;
    import tart.core.TartActor;

    use namespace tart_internal;

    /**
     * Layer object to manage 2D rendering order.
     */
    public class Layer2D extends TartActor implements ILayer {

        public static const STARLING_FORE:int = 1;
        public static const STARLING_BACK:int = 2;

        private var _layerName:String;
        private var _zOrder:int;
        private var _starlingId:int;
        private var _scope:ISceneScope;

        /**
         * @param layerName  - Name to retrieve this instance.
         * @param zOrder     - Large number means foreground.
         * @param starlingId - ID to specify target Starling instance.
         */
        public function Layer2D(layerName:String, zOrder:int,
                                starlingId:int=STARLING_FORE)
        {
            _layerName  = layerName;
            _zOrder     = zOrder;
            _starlingId = starlingId;
        }

        //----------------------------------------------------------------------
        // implements ILayer
        //----------------------------------------------------------------------

        public function get layerName():String {
            return _layerName;
        }

        public function get scope():ISceneScope {
            return _scope;
        }

        public function set scope(scope:ISceneScope):void {
            _scope = scope;
        }

        public function get layerActor():TartActor {
            return this;
        }

        public function onLayerCreated():void {
            var view2D:View2D = getComponent(View2D) as View2D;
            view2D.displayObj = new Sprite();

            var starling:Starling = getStarling(_starlingId);
            var rootSprite:Sprite = starling.root as Sprite;

            // ToDo: add sprite to starling.root with zOrder
        }

        public function onLayerDisposed():void {
            // ToDo
        }

        //----------------------------------------------------------------------
        // overrides TartActor
        //----------------------------------------------------------------------

        public override function recipe():Array {
            return [View2D];
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function getStarling(starlingId:int):Starling {
            return (starlingId == STARLING_FORE) ?
                tart.graphics.starlingFore :
                tart.graphics.starlingBack;
        }

    }
}
