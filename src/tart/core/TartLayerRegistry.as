package tart.core {

    import flash.utils.getQualifiedClassName;
    import flash.utils.Dictionary;

    import starling.display.DisplayObjectContainer;

    import dessert_knife.knife;

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
                if (layer.layerScope != scope) { continue; }

                delete _layers[layer.layerName];
                layer.onLayerDisposed();
            }
        }

        public function getLayer(layerName:String):ILayer {
            TART::LOG_WARN {
                if (!_layers[layerName]) {
                    trace("[Warn :: TartLayerRegistry] Layer not found:", layerName);
                }
            }
            return _layers[layerName];
        }

        /**
         * Helper for tart.actors.Layer2D
         */
        public function getLayer2DNode(layerName:String):DisplayObjectContainer {
            var layer:ILayer = getLayer(layerName);
            if (!(layer.layerUserData is DisplayObjectContainer)) {
                TART::LOG_ERROR {
                    trace("[Error :: TartLayerRegistry] 2D layer <", layerName,
                          "> should have DisplayObjectContainer");
                }
                return null;
            }

            return layer.layerUserData as DisplayObjectContainer;
        }

        //----------------------------------------------------------------------
        // debug commands
        //----------------------------------------------------------------------

        public function debug_dumpLayers():void {
            trace("[Debug :: TartLayerRegistry] ///// Layers /////");

            var maxLayerDescLength:int = _getMaxLayerDescLength();

            var list:Array = [];
            for (var layerName:String in _layers) {
                var layer:ILayer = _layers[layerName];
                list.push(
                    knife.str.padRight(layer.toString(), maxLayerDescLength) + "  :  "
                        + getQualifiedClassName(layer) + " ... ("
                        + getQualifiedClassName(layer.layerScope) + ")"
                );
            }
            list.sort();
            trace(JSON.stringify(list, null, 4));
        }

        private function _getMaxLayerDescLength():int {
            var maxLen:int = 0;
            for (var layerName:String in _layers) {
                var layer:ILayer = _layers[layerName];
                var descLen:int  = layer.toString().length;
                if (descLen > maxLen) {
                    maxLen = descLen;
                }
            }
            return maxLen;
        }

    }
}
