package {

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.system.System;
    import flash.utils.getTimer;

    import tartlab.data_structures.IIterator;
    import tartlab.data_structures.LinkedList;
    import tartlab.utils.PigmyButton;
    import tartlab.utils.PigmyConsole;

    public class BenchmarkTasks extends Sprite {

        private const TASK_UNIT:int = 300000;

        private var _mainConsole:PigmyConsole;
        private var _subConsole:PigmyConsole;

        public function BenchmarkTasks(mainConsole:PigmyConsole, subConsole:PigmyConsole) {
            _mainConsole = mainConsole;
            _subConsole  = subConsole;
        }

        public function getDispatchTable_1():Array {
            return [
                 ["clear console",              _clearConsole]
                ,["Garbage Collection",         _collectGarbage]
                ,["iterate Array w/ index",     _iterateTest_1]
                ,["iterate Array w/ for each",  _iterateTest_2]
                ,["iterate Vector w/ index",    _iterateTest_3]
                ,["iterate Vector w/ for each", _iterateTest_4]
                ,["iterate Linked List",        _iterateTest_5]
            ];
        }

        public function getDispatchTable_2():Array {
            return [
                 ["push()",                _pushTest_1]
                ,["push by index",         _pushTest_2]
                ,["push w/ insertAt",      _pushTest_3]
                ,["insert w/ splice",      _insertTest_1]
                ,["insert w/ insertAt",    _insertTest_2]
                ,["insert w/ Linked List", _insertTest_3]
                ,["shift()",               _shiftTest_1]
                ,["shift w/ splice",       _shiftTest_2]
                ,["shift w/ removeAt",     _shiftTest_3]
                ,["remove w/ splice",      _removeTest_1]
                ,["remove w/ removeAt",    _removeTest_2]
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

        // push normally
        private function _pushTest_1():void {
            _describe(TASK_UNIT + " times / array.push(*)");
            _benchmark(function():void {
                var list:Array = [];
                for (var i:int = 0; i < TASK_UNIT; ++i) {
                    list.push(Math.random());
                }
            });
        }

        // push by index
        private function _pushTest_2():void {
            _describe(TASK_UNIT + " times / array[array.length] = *");
            _benchmark(function():void {
                var list:Array = [];
                for (var i:int = 0; i < TASK_UNIT; ++i) {
                    list[list.length] = Math.random();
                }
            });
        }

        // push with new Array method
        private function _pushTest_3():void {
            _describe(TASK_UNIT + " times / array.insertAt(-1, *)");
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

        private function _makeVector(size:int):Vector.<int> {
            var vector:Vector.<int> = new Vector.<int>();
            for (var i:int = 0; i < size; ++i) {
                vector.push(i);
            }
            return vector;
        }

        // insert with traditional Array.splice()
        private function _insertTest_1():void {
            _describe(TASK_UNIT / 2 / 10 + " times / array.splice(i+1, 0, *)");

            var list:Array = _makeList(TASK_UNIT / 2);
            _benchmark(function():void {
                for (var i:int = 0; i < list.length; ++i) {
                    if (list[i] % 10 == 1) {
                        list.splice(i+1, 0, Math.random());
                    }
                }
            });
        }

        // insert with new Array method
        private function _insertTest_2():void {
            _describe(TASK_UNIT / 2 / 10 + " times / array.insertAt(i+1, *)");

            var list:Array = _makeList(TASK_UNIT / 2);
            _benchmark(function():void {
                for (var i:int = 0; i < list.length; ++i) {
                    if (list[i] % 10 == 1) {
                        list.insertAt(i+1, Math.random());
                    }
                }
            });
        }

        // insert with handmade Linked-List
        private function _insertTest_3():void {
            _describe(TASK_UNIT / 2 / 10 + " times / insert with Linked List");

            var list:LinkedList = new LinkedList();
            var iter:IIterator  = list.iterator();
            for (var i:int = 0; i < TASK_UNIT / 2; ++i) {
                list.push(i);
            }

            _benchmark(function():void {
                for (var item:* = iter.head(); item != null; item = iter.next()) {
                    if (int(item) % 10 == 1) {
                        iter.addAfter(Math.random());
                    }
                }
            });
        }

        // shift normally
        private function _shiftTest_1():void {
            _describe(TASK_UNIT / 8 + " times / array.shift()");

            var list:Array = _makeList(TASK_UNIT / 8);
            _benchmark(function():void {
                while(list.length > 0) {
                    list.shift();
                }
            });
        }

        // shift with traditional Array.splice()
        private function _shiftTest_2():void {
            _describe(TASK_UNIT / 8 + " times / array.splice(0, 1)");

            var list:Array = _makeList(TASK_UNIT / 8);
            _benchmark(function():void {
                while(list.length > 0) {
                    list.splice(0, 1);
                }
            });
        }

        // shift with new Array method
        private function _shiftTest_3():void {
            _describe(TASK_UNIT / 8 + " times / array.removeAt(0)");

            var list:Array = _makeList(TASK_UNIT / 8);
            _benchmark(function():void {
                while(list.length > 0) {
                    list.removeAt(0);
                }
            });
        }

        // remove with traditional Array.splice()
        private function _removeTest_1():void {
            _describe(TASK_UNIT / 2 / 10 + " times / array.splice(i, 1)");

            var list:Array = _makeList(TASK_UNIT / 2);
            _benchmark(function():void {
                for (var i:int = 0; i < list.length; ++i) {
                    if (i % 10 == 0) {
                        list.splice(i, 1);
                    }
                }
            });
        }

        // remove with new Array method
        private function _removeTest_2():void {
            _describe(TASK_UNIT / 2 + " times / array.removeAt(i)");

            var list:Array = _makeList(TASK_UNIT / 2);
            _benchmark(function():void {
                for (var i:int = 0; i < list.length; ++i) {
                    if (i % 10 == 0) {
                        list.removeAt(i);
                    }
                }
            });
        }

        // iterate Array with indexing
        private function _iterateTest_1():void {
            _describe(TASK_UNIT + " times / a = array[i]");

            var list:Array = _makeList(TASK_UNIT);
            _benchmark(function():void {
                var hoge:int;
                for (var i:int = 0; i < list.length; ++i) {
                    hoge = list[i];
                }
            });
        }

        // iterate Array with built-in syntax
        private function _iterateTest_2():void {
            _describe(TASK_UNIT + " elements Array iteration with for each");

            var list:Array = _makeList(TASK_UNIT);
            _benchmark(function():void {
                var hoge:int;
                for each (var i:int in list) {
                    hoge = i;
                }
            });
        }

        // iterate Vector with indexing
        private function _iterateTest_3():void {
            _describe(TASK_UNIT + " times / v = vector[i]");

            var vector:Vector.<int> = _makeVector(TASK_UNIT);
            _benchmark(function():void {
                var hoge:int;
                for (var i:int = 0; i < vector.length; ++i) {
                    hoge = vector[i];
                }
            });
        }

        // iterate Vector with built-in syntax
        private function _iterateTest_4():void {
            _describe(TASK_UNIT + " elements Vector iteration with for each");

            var vector:Vector.<int> = _makeVector(TASK_UNIT);
            _benchmark(function():void {
                var hoge:int;
                for each (var i:int in vector) {
                    hoge = i;
                }
            });
        }

        // iterate handmade Linked-List
        private function _iterateTest_5():void {
            _describe(TASK_UNIT + " nodes iteration of handmade Linked List");

            var list:LinkedList = new LinkedList();
            var iter:IIterator  = list.iterator();
            for (var i:int = 0; i < TASK_UNIT; ++i) {
                list.push(i);
            }

            _benchmark(function():void {
                var hoge:int;
                for (var item:* = iter.head(); item != null; item = iter.next()) {
                    hoge = item;
                }
            });
        }

    }
}
