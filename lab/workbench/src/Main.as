package {

    import flash.display.Sprite;
    import flash.system.Capabilities;

    public class Main extends Sprite {

        public function Main() {
            _centeringWindowForDesktopApp();
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

    }
}
