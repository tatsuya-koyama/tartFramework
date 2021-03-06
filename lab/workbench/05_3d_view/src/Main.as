package {

    import flash.display.Sprite;
    import flash.system.Capabilities;

    import tart.config.BootConfigPrototype;
    import tart.config.DefaultGraphicsBootConfig;
    import tart.core.TartContext;
    import tart.core.TartEngine;
    import tart.core.TartScene;

    import scenes.*;

    public class Main extends Sprite {

        public function Main() {
            _centeringWindowForDesktopApp();

            var bootConfig:BootConfigPrototype = new BootConfigPrototype();
            bootConfig.rootSprite      = this;
            bootConfig.firstScene      = new Scene_1();
            bootConfig.rootChapter     = new RootChapter();
            bootConfig.baseResourceUrl = "lab_assets/";
            bootConfig.base3dAssetUrl  = "lab_assets/meshes/";

            var graphicsConf:DefaultGraphicsBootConfig = new DefaultGraphicsBootConfig();
            graphicsConf.bgColor = 0xd2d2cc;
            bootConfig.graphicsBootConfig = graphicsConf;

            var engine:TartEngine = new TartEngine();
            engine.boot(bootConfig);
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

    }
}
