package {

    import flash.display.Sprite;
    import flash.system.Capabilities;

    import tart.config.BootConfigPrototype;
    import tart.core.TartContext;
    import tart.core.TartEngine;
    import tart.core.TartScene;

    import scenes.*;

    public class Main extends Sprite {

        public function Main() {
            _centeringWindowForDesktopApp();

            var bootConfig:BootConfigPrototype = new BootConfigPrototype();
            bootConfig.rootSprite    = this;
            bootConfig.firstScene    = new Scene_Global();
            bootConfig.globalChapter = new GlobalChapter();

            var engine:TartEngine = new TartEngine();
            engine.boot(bootConfig)
                .then(function(tartContext:TartContext):void {
                    DebugContext.tartContext = tartContext;
                });
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

    }
}
