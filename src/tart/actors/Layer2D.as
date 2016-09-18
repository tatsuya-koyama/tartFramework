package tart.actors {

    import starling.core.Starling;
    import starling.display.Sprite;

    import tart.components.View2D;
    import tart.core.tart_internal;
    import tart.core.ActorCore;
    import tart.core.ISceneScope;
    import tart.core.ILayer;
    import tart.starling_extension.OrderedSprite;

    import dessert_knife.knife;

    use namespace tart_internal;

    /**
     * Layer object to manage 2D rendering order.
     */
    public class Layer2D extends ActorCore implements ILayer {

        public static const STARLING_FORE:String = "Starling_Fore";
        public static const STARLING_BACK:String = "Starling_Back";

        private var _layerName:String;
        private var _zOrder:int;
        private var _starlingId:String;
        private var _scope:ISceneScope;

        /**
         * @param layerName  - Name to retrieve this instance.
         * @param zOrder     - Large number means foreground.
         * @param starlingId - ID to specify target Starling instance.
         */
        public function Layer2D(layerName:String, zOrder:int,
                                starlingId:String=STARLING_FORE)
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

        public function get layerScope():ISceneScope {
            return _scope;
        }

        public function set layerScope(scope:ISceneScope):void {
            _scope = scope;
        }

        public function get layerActor():ActorCore {
            return this;
        }

        /** Returns layer sprite. */
        public function get layerUserData():* {
            return _view2D.displayObj;
        }

        public function onLayerCreated():void {
            _view2D.displayObj = new OrderedSprite(_zOrder);

            var starling:Starling = _getStarling(_starlingId);
            var rootSprite:Sprite = starling.root as Sprite;

            rootSprite.addChild(_view2D.displayObj);
            _sortDisplayOrder(rootSprite);
        }

        public function onLayerDisposed():void {
            // Nothing to do: displayObj is removed automatically when actor is disposed.
        }

        public function toString():String {
            return _starlingId + " - "
                + knife.str.padLeft("" + _zOrder, 3, "0") + "."
                + _layerName;
        }

        //----------------------------------------------------------------------
        // overrides ActorCore
        //----------------------------------------------------------------------

        public override function recipe():Array {
            return [View2D];
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _getStarling(starlingId:String):Starling {
            return (starlingId == STARLING_FORE) ?
                tart.graphics.starlingFore :
                tart.graphics.starlingBack;
        }

        private function _sortDisplayOrder(parentSprite:Sprite):void {
            parentSprite.sortChildren(function(a:*, b:*):int {
                if (!(a is OrderedSprite)) { return 0; }
                if (!(b is OrderedSprite)) { return 0; }

                if (a.zOrder < b.zOrder) { return -1; }
                if (a.zOrder > b.zOrder) { return  1; }
                return 0;
            });
        }

    }
}
