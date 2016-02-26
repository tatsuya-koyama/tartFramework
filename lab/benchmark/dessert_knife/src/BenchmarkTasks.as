package {

    import flash.sampler.getSize
    import flash.system.System;
    import flash.utils.getTimer;

    import tartlab.utils.PigmyConsole;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Async;
    import dessert_knife.tools.async.Await;
    import dessert_knife.tools.async.Defer;
    import dessert_knife.tools.async.Deferred;
    import dessert_knife.tools.async.Promise;

    public class BenchmarkTasks {

        private const TASK_UNIT:int = 1000;
        private var _workingObj:*;

        private var _mainConsole:PigmyConsole;
        private var _subConsole:PigmyConsole;

        private var _startTime:int;
        private var _startMemory:uint;
        private var _endTime:int;
        private var _endMemory:uint;
        private var _elapsedTime:int;
        private var _consumedMemory:Number

        public function BenchmarkTasks(mainConsole:PigmyConsole, subConsole:PigmyConsole) {
            _mainConsole = mainConsole;
            _subConsole  = subConsole;
        }

        public function getDispatchTable_1():Array {
            return [
                 ["clear console",        _clearConsole]
                ,["Garbage Collection",   _collectGarbage]
                ,["Instance memory size", _instanceMemorySize]
            ];
        }

        public function getDispatchTable_2():Array {
            return [
                 ["Promise",                 _promise]
                ,["Promise (sync allowed)",  _promise_sync]
                ,["Deferred",                _deferred]
                ,["Deferred (sync allowed)", _deferred_sync]
                ,["Light-weight Defer",      _defer]
                ,["Async",                   _async]
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

        private function _startBenchmark():void {
            _workingObj = null;
            System.gc();
            _startTime   = getTimer();
            _startMemory = System.totalMemory;
        }

        private function _endBenchmark():void {
            _endTime        = getTimer();
            _endMemory      = System.totalMemory;
            _elapsedTime    = _endTime - _startTime;
            _consumedMemory = (_endMemory - _startMemory) / 1000000;

            _mainConsole.log("[Time] " + _elapsedTime + " ms  /  [Memory] " + _consumedMemory + " MB");
        }

        private function _describe(title:String):void {
            _subConsole.rewrite(title);
        }

        //----------------------------------------------------------------------
        // helpers
        //----------------------------------------------------------------------

        private function _promiseTask(input:int):Promise {
            return new Promise(function(resolve:Function, reject:Function):void {
                resolve(input);
            });
        }

        private function _promiseTask_sync(input:int):Promise {
            return knife.promise(function(resolve:Function, reject:Function):void {
                resolve(input);
            });
        }

        private function _deferredTask(input:int):Promise {
            var deferred:Deferred = new Deferred();
            deferred.done(input);
            return deferred.promise;
        }

        private function _deferredTask_sync(input:int):Promise {
            var deferred:Deferred = knife.deferred();
            deferred.done(input);
            return deferred.promise;
        }

        private function _deferTask(input:int):Defer {
            var defer:Defer = knife.defer();
            defer.done(input);
            return defer;
        }

        private function _asyncTask(async:Async):void {
            async.done();
        }

        //----------------------------------------------------------------------
        // benchmark tasks
        //----------------------------------------------------------------------

        private function _instanceMemorySize():void {
            _describe("Profile working object sizes");
            _mainConsole.log("Profile working object sizes:");

            var promise:Promise   = knife.promise(null);
            var deferred:Deferred = knife.deferred();
            var defer:Defer       = knife.defer();
            var async:Async       = new Async([]);

            _mainConsole.log("  Promise  : " + getSize(promise)  + " [Bytes]");
            _mainConsole.log("  Deferred : " + getSize(deferred) + " [Bytes]");
            _mainConsole.log("  Defer    : " + getSize(defer)    + " [Bytes]");
            _mainConsole.log("  Async    : " + getSize(async)    + " [Bytes]");
        }

        private function _promise():void {
            const NUM_TASK:int = TASK_UNIT;
            _describe("Promise: 8 times of then() * " + NUM_TASK);
            _startBenchmark();

            var count:int = 0;
            for (var i:int = 0; i < NUM_TASK; ++i) {
                _promiseTask(i)
                    .then(_promiseTask)
                    .then(_promiseTask)
                    .then(_promiseTask)
                    .then(_promiseTask)
                    .then(_promiseTask)
                    .then(_promiseTask)
                    .then(_promiseTask)
                    .then(function():void {
                        ++count;
                        if (count == NUM_TASK) { _endBenchmark(); }
                    });
            }
        }

        private function _promise_sync():void {
            const NUM_TASK:int = TASK_UNIT;
            _describe("Promise (resolve sync): 8 times of then() * " + NUM_TASK);
            _startBenchmark();

            var count:int = 0;
            for (var i:int = 0; i < NUM_TASK; ++i) {
                _promiseTask_sync(i)
                    .then(_promiseTask_sync)
                    .then(_promiseTask_sync)
                    .then(_promiseTask_sync)
                    .then(_promiseTask_sync)
                    .then(_promiseTask_sync)
                    .then(_promiseTask_sync)
                    .then(_promiseTask_sync)
                    .then(function():void {
                        ++count;
                        if (count == NUM_TASK) { _endBenchmark(); }
                    });
            }
        }

        private function _deferred():void {
            const NUM_TASK:int = TASK_UNIT;
            _describe("Deferred: 8 times of then() * " + NUM_TASK);
            _startBenchmark();

            var count:int = 0;
            for (var i:int = 0; i < NUM_TASK; ++i) {
                _deferredTask(i)
                    .then(_deferredTask)
                    .then(_deferredTask)
                    .then(_deferredTask)
                    .then(_deferredTask)
                    .then(_deferredTask)
                    .then(_deferredTask)
                    .then(_deferredTask)
                    .then(function():void {
                        ++count;
                        if (count == NUM_TASK) { _endBenchmark(); }
                    });
            }
        }

        private function _deferred_sync():void {
            const NUM_TASK:int = TASK_UNIT;
            _describe("Deferred (resolve sync): 8 times of then() * " + NUM_TASK);
            _startBenchmark();

            var count:int = 0;
            for (var i:int = 0; i < NUM_TASK; ++i) {
                _deferredTask_sync(i)
                    .then(_deferredTask_sync)
                    .then(_deferredTask_sync)
                    .then(_deferredTask_sync)
                    .then(_deferredTask_sync)
                    .then(_deferredTask_sync)
                    .then(_deferredTask_sync)
                    .then(_deferredTask_sync)
                    .then(function():void {
                        ++count;
                        if (count == NUM_TASK) { _endBenchmark(); }
                    });
            }
        }

        private function _defer():void {
            const NUM_TASK:int = TASK_UNIT;
            _describe("Defer: 8 times of then() * " + NUM_TASK);
            _startBenchmark();

            var count:int = 0;
            for (var i:int = 0; i < NUM_TASK; ++i) {
                _deferTask(i)
                    .then(_deferTask)
                    .then(_deferTask)
                    .then(_deferTask)
                    .then(_deferTask)
                    .then(_deferTask)
                    .then(_deferTask)
                    .then(_deferTask)
                    .then(function():void {
                        ++count;
                        if (count == NUM_TASK) { _endBenchmark(); }
                    });
            }
        }

        private function _async():void {
            const NUM_TASK:int = TASK_UNIT;
            _describe("Async: 8 task chain * " + NUM_TASK);
            _startBenchmark();

            var count:int = 0;
            for (var i:int = 0; i < NUM_TASK; ++i) {
                knife.async({
                    serial: [
                        _asyncTask,
                        _asyncTask,
                        _asyncTask,
                        _asyncTask,
                        _asyncTask,
                        _asyncTask,
                        _asyncTask,
                        _asyncTask,
                    ],
                    anyway: function():void {
                        ++count;
                        if (count == NUM_TASK) { _endBenchmark(); }
                    }
                });
            }
        }

    }
}
