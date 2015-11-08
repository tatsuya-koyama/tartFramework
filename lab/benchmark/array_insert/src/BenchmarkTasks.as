package {

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.system.System;
    import flash.utils.getTimer;

    import tartlab.utils.PigmyButton;
    import tartlab.utils.PigmyConsole;

    public class BenchmarkTasks extends Sprite {

        private const TASK_UNIT:int = 300000;

        private var _console:PigmyConsole;

        public function BenchmarkTasks(console:PigmyConsole) {
            _console = console;
        }

        public function getDispatchTable():Array {
            return [
                 ["Clear Console",            _clearConsole]
                ,["array.push(*)",            _pushTest_1]
                ,["array[array.length] = *",  _pushTest_2]
                ,["array.insertAt(-1, *)",    _pushTest_3]
                ,["array.splice(i, 0, *)",    _insertTest_1]
                ,["array.insertAt(i, *)",     _insertTest_2]
            ];
        }

        private function _clearConsole():void {
            _console.clear();
        }

        private function _benchmark(task:Function):void {
            var startTime:int    = getTimer();
            var startMemory:uint = System.totalMemory;

            task();

            var endTime:int     = getTimer();
            var endMemory:uint  = System.totalMemory;
            var elapsed:int     = endTime - startTime;
            var consumed:Number = (endMemory - startMemory) / 1000000;

            _console.log("[Time] " + elapsed + " ms  /  [Memory] " + consumed + " MB");
        }

        private function _pushTest_1():void {
            _benchmark(function():void {
                var list:Array = [];
                for (var i:int = 0; i < TASK_UNIT; ++i) {
                    list.push(Math.random());
                }
            });
        }

        private function _pushTest_2():void {
            _benchmark(function():void {
                var list:Array = [];
                for (var i:int = 0; i < TASK_UNIT; ++i) {
                    list[list.length] = Math.random();
                }
            });
        }

        private function _pushTest_3():void {
            _benchmark(function():void {
                var list:Array = [];
                for (var i:int = 0; i < TASK_UNIT; ++i) {
                    list.insertAt(-1, Math.random());
                }
            });
        }

        private function _makeList(size:int):Array {
            var list:Array = [];
            for (var i:int = 0; i < size; ++i) {
                list.push(i);
            }
            return list;
        }

        private function _insertTest_1():void {
            var list:Array = _makeList(TASK_UNIT / 2);
            _benchmark(function():void {
                for (var i:int = 0; i < list.length; ++i) {
                    if (i % 10 == 0) {
                        list.splice(i, 0, Math.random());
                    }
                }
            });
        }

        private function _insertTest_2():void {
            var list:Array = _makeList(TASK_UNIT / 2);
            _benchmark(function():void {
                for (var i:int = 0; i < list.length; ++i) {
                    if (i % 10 == 0) {
                        list.insertAt(i, Math.random());
                    }
                }
            });
        }

    }
}
