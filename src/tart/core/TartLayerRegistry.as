package tart.core {

    import flash.utils.getQualifiedClassName;
    import flash.utils.Dictionary;

    public class TartLayerRegistry {

        private var _layers:Dictionary;  // {"Layer name" : <ILayer>}

        public function TartLayerRegistry() {
            _layers = new Dictionary();
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function addLayer(layer:ILayer):void {
            if (_layers[layer.layerName]) {
                TART::LOG_WARN {
                    trace("[Warn :: TartLayerRegistry] Layer name is already used:",
                          layer.layerName);
                }
                return;
            }

            _layers[layer.layerName] = layer;
            layer.onLayerCreated();
        }

        public function removeScopeLayers(scope:ISceneScope):void {
            for (var layerName:String in _layers) {
                var layer:ILayer = _layers[layerName];
                if (layer.scope != scope) { continue; }

                delete _layers[layer.layerName];
                layer.onLayerDisposed();
            }
        }

        //----------------------------------------------------------------------
        // debug commands
        //----------------------------------------------------------------------

        public function debug_dumpLayers():void {
            trace("[Debug :: TartLayerRegistry] ***** {layerName : layer - scope} *****");
            var obj:Object = {};
            for (var layerName:String in _layers) {
                var layer:ILayer = _layers[layerName];
                obj[layerName] =
                    getQualifiedClassName(layer) + " - " +
                    getQualifiedClassName(layer.scope);
            }
            trace(JSON.stringify(obj, null, 4));
        }

    }
}
