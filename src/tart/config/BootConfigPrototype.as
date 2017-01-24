package tart.config {

    import flash.display.Sprite;

    import tart.core.IBootConfig;
    import tart.core.IGraphicsBootConfig;
    import tart.core.IResourceBootConfig;
    import tart.core.ISystemBootConfig;
    import tart.core.TartChapter;
    import tart.core.TartScene;

    public class BootConfigPrototype implements IBootConfig {

        private var _rootSprite:Sprite;
        private var _firstScene:TartScene;
        private var _rootChapter:TartChapter;
        private var _baseResourceUrl:String;
        private var _base3dAssetUrl:String;

        private var _graphicsBootConfig:IGraphicsBootConfig;
        private var _resourceBootConfig:IResourceBootConfig;
        private var _systemBootConfig:ISystemBootConfig;

        // Set params before pass to TartEngine.boot()
        public function set rootSprite(sprite:Sprite):void { _rootSprite = sprite; }
        public function set firstScene(scene:TartScene):void { _firstScene = scene; }

        // [Optional params]
        public function set rootChapter(chapter:TartChapter):void { _rootChapter = chapter; }
        public function set baseResourceUrl(url:String):void { _baseResourceUrl = url; }
        public function set base3dAssetUrl(url:String):void { _base3dAssetUrl = url; }
        public function set graphicsBootConfig(config:IGraphicsBootConfig):void { _graphicsBootConfig = config; }
        public function set resourceBootConfig(config:IResourceBootConfig):void { _resourceBootConfig = config; }
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

        public function get rootChapter():TartChapter {
            return _rootChapter;
        }

        public function get resourceBootConfig():IResourceBootConfig {
            if (!_resourceBootConfig) {
                _resourceBootConfig = new DefaultResourceBootConfig(_baseResourceUrl, _base3dAssetUrl);
            }
            return _resourceBootConfig;
        }

        public function get graphicsBootConfig():IGraphicsBootConfig {
            if (!_graphicsBootConfig) {
                _graphicsBootConfig = new DefaultGraphicsBootConfig();
            }
            return _graphicsBootConfig;
        }

        public function get systemBootConfig():ISystemBootConfig {
            if (!_systemBootConfig) {
                _systemBootConfig = new DefaultSystemBootConfig();
            }
            return _systemBootConfig;
        }

    }
}
