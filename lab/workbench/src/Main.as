package {

    import flash.display.Sprite;
    import flash.system.Capabilities;

    import tart.config.BootConfigPrototype;
    import tart.core.TartEngine;

    public class Main extends Sprite {

        public function Main() {
            _centeringWindowForDesktopApp();

            var bootConfig:BootConfigPrototype = new BootConfigPrototype();
            bootConfig.rootSprite = this;
            bootConfig.firstScene = null;

            new TartEngine().boot(bootConfig);
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

    }
}
