package tart.core {

    import flash.display.Sprite;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class BootSequence {

        private var _bootConfig:IBootConfig;

        public function BootSequence(bootConfig:IBootConfig) {
            _bootConfig = bootConfig;
        }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function runAsync(tartContext:TartContext):Defer {
            return _initGraphicsAsync(tartContext)
                .then(_initResource)
                .then(_initSystem)
                .then(_initLayerRegistry)
                .then(_initKeyboard)
                .then(_initDirectorAsync);
        }

        //----------------------------------------------------------------------
        // private
        //----------------------------------------------------------------------

        private function _initGraphicsAsync(tartContext:TartContext):Defer {
            var defer:Defer = knife.defer();
            tartContext.graphics = new TartGraphics();
            tartContext.graphics.init(
                _bootConfig.rootSprite,
                _bootConfig.graphicsBootConfig,
                defer.ender(tartContext)
            );
            return defer;
        }

        private function _initResource(tartContext:TartContext):TartContext {
            tartContext.resource = new TartResource();
            tartContext.resource.init(_bootConfig.resourceBootConfig);
            return tartContext;
        }

        private function _initSystem(tartContext:TartContext):TartContext {
            tartContext.system = new TartSystem(tartContext);
            tartContext.system.init(_bootConfig.systemBootConfig);
            return tartContext;
        }

        private function _initLayerRegistry(tartContext:TartContext):TartContext {
            tartContext.layers = new TartLayerRegistry();
            return tartContext;
        }

        private function _initKeyboard(tartContext:TartContext):TartContext {
            tartContext.keyboard = new TartKeyboard();
            tartContext.keyboard.init(_bootConfig.rootSprite.stage);
            return tartContext;
        }

        /**
         * Initialize TartDirector and then enter the scope which is entry point of the game.
         * This should be called after initialization of TartResource and TartLayerRegistry.
         */
        private function _initDirectorAsync(tartContext:TartContext):Defer {
            tartContext.director = new TartDirector(
                tartContext,
                _bootConfig.firstScene,
                _bootConfig.rootChapter
            );
            return tartContext.director.setupAsync().then(function():TartContext {
                return tartContext;
            });
        }

    }
}
