package tart.core_internal {

    import flash.utils.getQualifiedClassName;

    import tart.core.tart_internal;
    import tart.core.ActorCore;
    import tart.core.Entity;
    import tart.core.ILayer;
    import tart.core.ISceneScope;
    import tart.core.TartContext;
    import tart.core.TartEngine;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    use namespace tart_internal;

    public class TransitionSequence {

        private var _tartContext:TartContext;

        public function TransitionSequence(tartContext:TartContext) {
            _tartContext = tartContext;
        }

        //----------------------------------------------------------------------
        // Enter process
        //----------------------------------------------------------------------

        public function enterScopeAsync(scope:ISceneScope):Defer {
            TART::LOG_DEBUG {
                trace("[Debug :: TartDirector] --> Enter:",
                      getQualifiedClassName(scope));
            }

            scope.tart = _tartContext;
            scope.awake();
            return _loadScopeResourceAsync(scope)
                .then(scope.initAsync)
                .then(scope.init)
                .then(function():void { _createLayers(scope); })
                .then(function():void { _createInitialActors(scope); });
        }

        private function _loadScopeResourceAsync(scope:ISceneScope):Defer {
            var defer:Defer = knife.defer();
            var urls:Array  = scope.assets();
            if (!urls) {
                return defer.done();
            }

            _tartContext.resource.loadAssetsAsync(urls).then(defer.ender());
            return defer;
        }

        private function _createLayers(scope:ISceneScope):void {
            var layers:Array = scope.layers();
            if (layers) {
                var engine:TartEngine = _tartContext.engine;
                for each (var layer:ILayer in layers) {
                    layer.layerScope = scope;
                    var entity:Entity = engine.buildActor(layer.layerActor);
                    engine.addEntity(entity, scope);
                    _tartContext.layers.addLayer(layer);
                }
            }

            TART::LOG_DEBUG {
                _tartContext.layers.debug_dumpLayers();
            }
        }

        private function _createInitialActors(scope:ISceneScope):void {
            var actors:Array = scope.initialActors();
            if (!actors) { return; }

            var engine:TartEngine = _tartContext.engine;
            for each (var actor:ActorCore in actors) {
                var entity:Entity = engine.buildActor(actor);
                engine.addEntity(entity, scope);
            }
        }

        //----------------------------------------------------------------------
        // Exit process
        //----------------------------------------------------------------------

        public function exitScopeAsync(scope:ISceneScope):Defer {
            if (!scope) { return knife.defer().done(); }
            TART::LOG_DEBUG {
                trace("[Debug :: TartDirector] <-- Exit :",
                      getQualifiedClassName(scope));
            }

            return knife.defer().done()
                .then(scope.disposeAsync)
                .then(function():void { scope.dispose(); })
                .then(function():void { _disposeScopeResource(scope); })
                .then(function():void { _disposeScopeActors(scope); })
                .then(function():void { _disposeScopeLayers(scope); });
        }

        private function _disposeScopeResource(scope:ISceneScope):void {
            var urls:Array  = scope.assets();
            if (!urls) { return; }

            _tartContext.resource.releaseAssets(urls);
        }

        private function _disposeScopeActors(scope:ISceneScope):void {
            _tartContext.engine.disposeScopeEntities(scope);
            _tartContext.engine.disposePendingEntities();
        }

        private function _disposeScopeLayers(scope:ISceneScope):void {
            _tartContext.layers.removeScopeLayers(scope);
        }

    }
}
