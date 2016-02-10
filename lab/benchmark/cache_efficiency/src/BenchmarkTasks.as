package {

    import flash.system.System;
    import flash.utils.getTimer;

    import tartlab.utils.PigmyConsole;

    public class BenchmarkTasks {

        private const TASK_UNIT:int = 100000;
        private var _workingObj:*;

        private var _mainConsole:PigmyConsole;
        private var _subConsole:PigmyConsole;

        public function BenchmarkTasks(mainConsole:PigmyConsole, subConsole:PigmyConsole) {
            _mainConsole = mainConsole;
            _subConsole  = subConsole;
        }

        public function getDispatchTable_1():Array {
            return [
                 ["clear console",               _clearConsole]
                ,["Garbage Collection",          _collectGarbage]
                ,["iterate Vector sequentially", _iterateTest_VA1]
            ];
        }

        public function getDispatchTable_2():Array {
            return [
                 ["iterate sequentially",    _iterateTest_A1]
                ,["iterate at 16 intervals", _iterateTest_A2]
                ,["iterate at 64 intervals", _iterateTest_A3]
                ,["iterate 4 arrays",        _iterateTest_B1]
                ,["iterate at random",       _iterateTest_C1]
                ,["iterate 2D array",        _iterateTest_D1]
            ];
        }

        private function _clearConsole():void {
            _describe("clear console");
            _mainConsole.clear();
        }

        private function _collectGarbage():void {
            System.gc();
        }

        private function _benchmark(task:Function):void {
            _workingObj = null;
            System.gc();
            var startTime:int    = getTimer();
            var startMemory:uint = System.totalMemory;

            task();

            var endTime:int     = getTimer();
            var endMemory:uint  = System.totalMemory;
            var elapsed:int     = endTime - startTime;
            var consumed:Number = (endMemory - startMemory) / 1000000;

            _mainConsole.log("[Time] " + elapsed + " ms  /  [Memory] " + consumed + " MB");
        }

        private function _describe(title:String):void {
            _subConsole.rewrite(title);
        }

        private function _makeFilledArray(length:int):Array {
            var data:Array = new Array(length);
            for (var i:int = 0; i < data.length; ++i) {
                data[i] = 1;
            }
            return data;
        }

        private function _makeFilledVector(length:int):Vector.<int> {
            var data:Vector.<int> = new Vector.<int>(length);
            for (var i:int = 0; i < data.length; ++i) {
                data[i] = 1;
            }
            return data;
        }

        //----------------------------------------------------------------------
        // benchmark tasks
        //----------------------------------------------------------------------

        // iterate int array sequentially
        private function _iterateTest_A1():void {
            const DATA_LENGTH:int = TASK_UNIT * 4;
            _describe("Iterate " + DATA_LENGTH + " elements of Array at 1 interval");

            var data:Array = _makeFilledArray(DATA_LENGTH);
            _benchmark(function():void {
                var sum:int = 0;
                for (var i:int = 0; i < DATA_LENGTH; ++i) {
                    sum += data[i];
                }
            });
            _workingObj = data;
        }

        // iterate int array at 16 index intervals
        private function _iterateTest_A2():void {
            const DATA_LENGTH:int = TASK_UNIT * 4 * 16;
            _describe("Iterate " + DATA_LENGTH + " elements of Array at 16 intervals");

            var data:Array = _makeFilledArray(DATA_LENGTH);
            _benchmark(function():void {
                var sum:int = 0;
                for (var i:int = 0; i < DATA_LENGTH; i += 16) {
                    sum += data[i];
                }
            });
            _workingObj = data;
        }

        // iterate int array at 64 index intervals
        private function _iterateTest_A3():void {
            const DATA_LENGTH:int = TASK_UNIT * 4 * 64;
            _describe("Iterate " + DATA_LENGTH + " elements of Array at 64 intervals");

            var data:Array = _makeFilledArray(DATA_LENGTH);
            _benchmark(function():void {
                var sum:int = 0;
                for (var i:int = 0; i < DATA_LENGTH; i += 64) {
                    sum += data[i];
                }
            });
            _workingObj = data;
        }

        // iterate 4 arrays in parallel
        private function _iterateTest_B1():void {
            const DATA_LENGTH:int = TASK_UNIT * 1;
            _describe("Iterate 4 x " + DATA_LENGTH + " elements of Array at 1 interval");

            var dataList:Array = [];
            for (var i:int = 0; i < 4; ++i) {
                dataList.push(_makeFilledArray(DATA_LENGTH));
            }

            _benchmark(function():void {
                var sum:int = 0;
                for each (var data:Array in dataList) {
                    for (var i:int = 0; i < DATA_LENGTH; ++i) {
                        sum += data[i];
                    }
                }
            });
            _workingObj = dataList;
        }

        // iterate int vector sequentially
        private function _iterateTest_VA1():void {
            const DATA_LENGTH:int = TASK_UNIT * 4;
            _describe("Iterate " + DATA_LENGTH + " elements of Vector at 1 interval");

            var data:Vector.<int> = _makeFilledVector(DATA_LENGTH);
            _benchmark(function():void {
                var sum:int = 0;
                for (var i:int = 0; i < DATA_LENGTH; ++i) {
                    sum += data[i];
                }
            });
            _workingObj = data;
        }

        // iterate array at (pseudo) random index
        private function _iterateTest_C1():void {
            const DATA_LENGTH:int = TASK_UNIT * 4;
            _describe("Iterate " + DATA_LENGTH + " elements of Array at random index");

            var data:Array = _makeFilledArray(DATA_LENGTH);
            _benchmark(function():void {
                var sum:int = 0;
                for (var i:int = 0; i < DATA_LENGTH; i += 2) {
                    sum += data[i];
                    sum += data[DATA_LENGTH - i];
                }
            });
            _workingObj = data;
        }

        // iterate array of array
        private function _iterateTest_D1():void {
            const DATA_LENGTH:int = TASK_UNIT * 4;
            _describe("Iterate " + DATA_LENGTH + " elements of 2D Array");

            var dataList:Array = [];
            for (var i:int = 0; i < DATA_LENGTH; ++i) {
                var data:Array = new Array(64);
                data[0] = 1;
                dataList.push(data);
            }

            _benchmark(function():void {
                var sum:int = 0;
                for (var i:int = 0; i < DATA_LENGTH; ++i) {
                    sum += dataList[i][0];
                }
            });
            _workingObj = dataList;
        }

    }
}
