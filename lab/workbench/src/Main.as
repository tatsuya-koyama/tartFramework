package {

    import flash.display.Sprite;
    import flash.system.Capabilities;

    import tart.core.TartDirector;

    import dessert_knife.knife;
    import dessert_knife.blades.RandomKnife;

    public class Main extends Sprite {

        public function Main() {
            _centeringWindowForDesktopApp();

            var director:TartDirector = new TartDirector();
            director.boot(this);
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

    }
}
