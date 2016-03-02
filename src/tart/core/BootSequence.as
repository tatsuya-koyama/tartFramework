package tart.core {

    import flash.display.Sprite;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Defer;

    public class BootSequence {

        private var _tartContext:TartContext;
        private var _bootConfig:IBootConfig;



        private var _rootSprite:Sprite;
        private var _firstScene:TartScene;

        public function BootSequence(bootConfig:IBootConfig) {
            _bootConfig = bootConfig;
        }

        public function runAsync():Defer {
            var tartContext:TartContext = new TartContext();

            return _initGraphicsAsync(tartContext)
                .then(_initResource)
                .then(_initDirector)
                .then(_initSystem);
        }

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
            return tartContext;
        }

        private function _initDirector(tartContext:TartContext):TartContext {
            tartContext.director = new TartDirector(_bootConfig.firstScene);
            return tartContext;
        }

        private function _initSystem(tartContext:TartContext):TartContext {
            tartContext.system = new TartSystem();
            return tartContext;
        }

    }
}
