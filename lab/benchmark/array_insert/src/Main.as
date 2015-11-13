package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.system.System;

    import tartlab.utils.PigmyButton;
    import tartlab.utils.PigmyConsole;

    public class Main extends Sprite {

        private const TASK_UNIT:int = 300000;

        private var _mainConsole:PigmyConsole;
        private var _subConsole:PigmyConsole;
        private var _monitorConsole:PigmyConsole;
        private var _frame:int = -1;

        public function Main() {
            _centeringWindowForDesktopApp();
            _initConsole();

            var tasks:BenchmarkTasks = new BenchmarkTasks(_mainConsole, _subConsole);
            _initButtons(tasks);

            addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        }

        private function _centeringWindowForDesktopApp():void {
            PLATFORM::DESKTOP {
                stage.nativeWindow.x = (Capabilities.screenResolutionX - stage.nativeWindow.width)  * 0.5;
                stage.nativeWindow.y = (Capabilities.screenResolutionY - stage.nativeWindow.height) * 0.5;
            }
        }

        private function _initConsole():void {
            const LEFT:Number  = 320;
            const WIDTH:Number = 610;

            _mainConsole    = new PigmyConsole(LEFT, 80, WIDTH, 540);
            _subConsole     = new PigmyConsole(LEFT, 50, WIDTH, 22, 14, 0xeecc99);
            _monitorConsole = new PigmyConsole(LEFT, 20, WIDTH, 22, 14, 0xccee88);

            addChild(_mainConsole);
            addChild(_subConsole);
            addChild(_monitorConsole);
        }

        private function _initButtons(tasks:BenchmarkTasks):void {
            _initButtonsColumn(tasks.getDispatchTable_1(),  20);
            _initButtonsColumn(tasks.getDispatchTable_2(), 160);
        }

        private function _initButtonsColumn(dispatchTable:Array,
                                            leftX:Number=20, topY:Number=20,
                                            width:Number=130, height:Number=50,
                                            marginY:Number=5, fontSize:Number=14):void
        {
            var offsetY:int = topY;
            var getHandler:Function = function(func:Function):Function {
                return function(event:MouseEvent):void { func(); };
            }

            for each (var commandInfo:Array in dispatchTable) {
                var onClick:Function   = getHandler(commandInfo[1]);
                var buttonLabel:String = commandInfo[0];

                var button:PigmyButton = new PigmyButton(
                    onClick, buttonLabel,
                    leftX, offsetY, width, height, fontSize
                );
                addChild(button);

                offsetY += (height + marginY);
            }
        }

        private function _onEnterFrame(event:Event):void {
            ++_frame;
            if (_frame % 8 != 0) { return; }

            _monitorConsole.rewrite("Memory: " + System.totalMemory / 1000000 + " MB");
        }

    }
}
