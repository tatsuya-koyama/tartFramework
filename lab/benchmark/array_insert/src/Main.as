package {

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.system.System;
    import flash.utils.getTimer;

    import tartlab.utils.PigmyButton;
    import tartlab.utils.PigmyConsole;

    public class Main extends Sprite {

        private const TASK_UNIT:int = 300000;

        private var _console:PigmyConsole;

        public function Main() {
            _centeringWindowForDesktopApp();
            _initConsole();

            var tasks:BenchmarkTasks = new BenchmarkTasks(_console);
            _initButtons(tasks);
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

        private function _initConsole():void {
            _console = new PigmyConsole(250, 20, 660, 600);
            addChild(_console);
        }

        private function _initButtons(tasks:BenchmarkTasks):void {
            var dispatchTable:Array = tasks.getDispatchTable();
            var offsetY:int = 20;
            var getHandler:Function = function(func:Function):Function {
                return function(event:MouseEvent):void { func(); };
            }

            for each (var commandInfo:Array in dispatchTable) {
                var onClick:Function   = getHandler(commandInfo[1]);
                var buttonLabel:String = commandInfo[0];

                var button:PigmyButton = new PigmyButton(
                    onClick, buttonLabel,
                    20, offsetY, 200, 40, 14
                );
                addChild(button);

                offsetY += 50;
            }
        }

    }
}
