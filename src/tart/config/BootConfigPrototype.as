package tart.config {

    import flash.display.Sprite;

    import tart.core.IBootConfig;
    import tart.core.IGraphicsBootConfig;
    import tart.core.ISystemBootConfig;
    import tart.core.TartScene;

    public class BootConfigPrototype implements IBootConfig {

        private var _rootSprite:Sprite;
        private var _firstScene:TartScene;
        private var _graphicsBootConfig:IGraphicsBootConfig;
        private var _systemBootConfig:ISystemBootConfig;

        // Set params before pass to TartEngine.boot()
        public function set rootSprite(sprite:Sprite):void { _rootSprite = sprite; }
        public function set firstScene(scene:TartScene):void { _firstScene = scene; }

        // [Optional params]
        public function set graphicsBootConfig(config:IGraphicsBootConfig):void { _graphicsBootConfig = config; }
        public function set systemBootConfig(config:ISystemBootConfig):void { _systemBootConfig = config; }

        //----------------------------------------------------------------------
        // implements IBootConfig
        //----------------------------------------------------------------------

        public function get rootSprite():Sprite {
            return _rootSprite;
        }

        public function get firstScene():TartScene {
            return _firstScene;
        }

        public function get graphicsBootConfig():IGraphicsBootConfig {
            return _graphicsBootConfig;
        }

        public function get systemBootConfig():ISystemBootConfig {
            return _systemBootConfig;
        }

    }
}
