package {

    import flash.display.Sprite;
    import flash.system.Capabilities;

    import tart.config.BootConfigPrototype;
    import tart.core.TartEngine;
    import tart.core.TartScene;

    import scenes.*;
    import flash.utils.setTimeout;

    public class Main extends Sprite {

        public function Main() {
            _centeringWindowForDesktopApp();

            var bootConfig:BootConfigPrototype = new BootConfigPrototype();
            bootConfig.rootSprite  = this;
            bootConfig.firstScene  = new Scene_Root();
            bootConfig.rootChapter = new RootChapter();

            var engine:TartEngine = new TartEngine();
            engine.boot(bootConfig);

            _sceneTransitionTest(engine);
        }

        /**
         * {
         *     "scenes::RootChapter": [
         *         "scenes::Scene_Root",
         *         {
         *             "scenes::Chapter_1": [
         *                 "scenes::Scene_1A",
         *                 "scenes::Scene_1B",
         *                 {
         *                     "scenes::Chapter_1_2": [
         *                         "scenes::Scene_1_2A",
         *                         "scenes::Scene_1_2B"
         *                     ]
         *                 }
         *             ]
         *         },
         *         {
         *             "scenes::Chapter_2": [
         *                 "scenes::Scene_2B",
         *                 "scenes::Scene_2A"
         *             ]
         *         }
         *     ]
         *
         *     // Unregistered Scenes:
         *         - "scenes::Scene_Stray_A"
         *         - "scenes::Scene_Stray_B"
         * }
         */
        private function _sceneTransitionTest(engine:TartEngine):void {
            var navigate:Function = function(scene:TartScene):void {
                engine.tartContext.director.navigateTo(scene);
            };

            setTimeout(function():void {
                trace("\n *************** 1 ***************");
                navigate(new Scene_1_2B());
                navigate(new Scene_1_2A()); // this will be rejected
            }, 1500);

            setTimeout(function():void {
                trace("\n *************** 2 ***************");
                navigate(new Scene_2A());
            }, 4000);

            setTimeout(function():void {
                // Chapter_1's dispose process takes time, now is under transition.
                // This request will be rejected.
                navigate(new Scene_2B());
            }, 5000);

            setTimeout(function():void {
                trace("\n *************** 3 ***************");
                navigate(new Scene_Stray_A());
            }, 6500);

            setTimeout(function():void {
                trace("\n *************** 4 ***************");
                navigate(new Scene_Stray_B());
            }, 8000);

            setTimeout(function():void {
                trace("\n *************** 5 ***************");
                navigate(new Scene_1_2A());
            }, 9500);
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

    }
}
