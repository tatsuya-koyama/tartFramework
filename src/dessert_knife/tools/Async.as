package dessert_knife.tools {

    /**
     * Flexible asynchronous tasker.
     *
     * <p>Usage:</p>
     * <listing>
     *     //--- Basic sequential task
     *     var async:Async = new Async({
     *         serial : [function_1, function_2, function_3],
     *         error  : _onErrorHandler,
     *         anyway : _onFinallyHandler
     *     });
     *     async.go();
     * 
     * 
     *     //--- Parallel task
     *     var async:Async = new Async({
     *         parallel: [function_1, function_2, function_3],
     *         error   : _onErrorHandler,
     *         anyway  : _onFinallyHandler
     *     });
     *     async.go();
     * 
     *     * Throws error if both 'serial' and 'parallel' are given.
     * 
     * 
     *     //--- Function receives Async instance,
     *     //    and you should call its done() or fail().
     * 
     *     var async:Async = new Async({
     *         serial: [
     *             function(async:Async):void {
     *                 if (TASK_IS_SUCCEEDED) {
     *                     async.done();
     *                 } else {
     *                     async.fail();
     *                 }
     *             }
     *         ]
     *     });
     * 
     * 
     *     //--- Sub task
     *     var async:Async = new Async({
     *         serial: [
     *             function_1,
     *             function_2,
     *             {parallel: [
     *                 function_3,
     *                 function_4,
     *                 {serial: [
     *                     function_5,
     *                     function_6
     *                 ]}
     *             ]},
     *             function_7
     *         ],
     *         success: _onSuccessHandler,
     *         error  : _onErrorHandler,
     *         anyway : _onFinallyHandler
     *     });
     *     async.go();
     * 
     *     [Sequence]:
     *                   |3 ------>|
     *                   |         |
     *         1 -> 2 -> |4 ------>| -> 7 -> success -> anyway
     *                   |         |        (or error)
     *                   |5 -> 6 ->|
     * </listing>
     *
     * @param asyncDef Object or Function or instance of Async. Example:
     * <listing>
     *     var async:Async = new Async(<asyncDef>);
     * 
     *     <asyncDef> ::= {
     *         single  : function(async:Async):void {}  // Async uses internally
     *         // OR
     *         serial  : [<asyncDef>, ... ]
     *         // OR
     *         parallel: [<asyncDef>, ... ]
     *
     *         success : function():void {},  // optional
     *         error   : function():void {},  // optional
     *         anyway  : function():void {}   // optional
     *     }
     * 
     *     * If <asyncDef> == Function, then it is converted into:
     *         {single: Function}
     * 
     *     * You can use class instances instead of asyncDef object:
     * 
     *         public class MyAsyncTask extends Async {
     *             public function MyAsyncTask() {
     *                 super({
     *                     parallel: [method_1, method_2, method_3]
     *                 });
     *             }
     *         }
     * 
     *         var async:Async = new Async({
     *             serial: [
     *                 function_1,
     *                 new MyAsyncTask(),
     *                 function_2
     *             ]
     *         });
     * </pre>
     */
    public class Async {

        private var _myTask:Function;
        private var _errorHandler:Function;
        private var _successHandler:Function;
        private var _finallyHandler:Function;

        private var _serialTasks  :Vector.<Async>;
        private var _parallelTasks:Vector.<Async>;

        private var _serialTaskIndex:int = 0;
        private var _onComplete:Function = null;

        public static const UNDEF   :int = 1;
        public static const RESOLVED:int = 2;
        public static const REJECTED:int = 3;

        private var _state:int = Async.UNDEF;

        private var _isResolved :Boolean = false;
        private var _isRejected :Boolean = false;
        private var _isFinalized:Boolean = false;

        //----------------------------------------------------------------------
        public function Async(asyncDef:*) {
            if (asyncDef is Function) {
                _initWithFunction(asyncDef);
                return;
            }
            if (asyncDef is Async) {
                _initWithAsync(asyncDef);
                return;
            }
            if (asyncDef is Array) {
                _initWithArray(asyncDef);
                return;
            }
            if (asyncDef is Object) {
                _initWithObject(asyncDef);
                return;
            }
        }

        //----------------------------------------------------------------------
        // accessors
        //----------------------------------------------------------------------

        public function get myTask()        :Function { return _myTask; }
        public function get errorHandler()  :Function { return _errorHandler; }
        public function get successHandler():Function { return _successHandler; }
        public function get finallyHandler():Function { return _finallyHandler; }

        public function get serialTasks()  :Vector.<Async> { return _serialTasks; }
        public function get parallelTasks():Vector.<Async> { return _parallelTasks; }

        public function get state():int { return _state; }

        //----------------------------------------------------------------------
        // public
        //----------------------------------------------------------------------

        public function go(onComplete:Function=null):void {
            if (onComplete != null) {
                _onComplete = onComplete;
            }

            if (_myTask != null) {
                _myTask(this);
                return;
            }

            if (_serialTasks != null) {
                _kickNextSerialTask();
                return;
            }

            if (_parallelTasks != null) {
                _kickParallelTasks();
                return;
            }
        }

        public function done():void {
            _state = Async.RESOLVED;
            _finalize();
        }

        public function fail():void {
            _state = Async.REJECTED;
            _finalize();
        }

        //----------------------------------------------------------------------
        // initializer
        //----------------------------------------------------------------------

        private function _initWithObject(asyncDef:Object):void {
            _validateInitObject(asyncDef);

            if (asyncDef.single   != null) { _myTask = asyncDef.single; }
            if (asyncDef.serial   != null) { _serialTasks   = _makeChildren(asyncDef.serial); }
            if (asyncDef.parallel != null) { _parallelTasks = _makeChildren(asyncDef.parallel); }

            if (asyncDef.success  != null) { _successHandler = asyncDef.success; }
            if (asyncDef.error    != null) { _errorHandler   = asyncDef.error; }
            if (asyncDef.anyway   != null) { _finallyHandler = asyncDef.anyway; }
        }

        private function _validateInitObject(asyncDef:Object):void {
            var exclusiveDefCount:uint = 0;
            if (asyncDef.single   != null) { ++exclusiveDefCount; }
            if (asyncDef.serial   != null) { ++exclusiveDefCount; }
            if (asyncDef.parallel != null) { ++exclusiveDefCount; }

            if (exclusiveDefCount != 1) {
                throw new Error("[DessertKnife::Async] Error: Invalid async task definition.");
            }
        }

        private function _makeChildren(asyncDefList:Array):Vector.<Async> {
            var children:Vector.<Async> = new Vector.<Async>;

            for each (var def:* in asyncDefList) {
                var async:Async = (def is Async) ? def : new Async(def);
                children.push(async);
            }
            return children;
        }

        private function _initWithFunction(asyncDef:Function):void {
            _initWithObject({
                single: asyncDef
            });
        }

        private function _initWithArray(asyncDef:Array):void {
            _initWithObject({
                serial: asyncDef
            });
        }

        private function _initWithAsync(asyncDef:Async):void {
            _myTask         = asyncDef.myTask;
            _successHandler = asyncDef.successHandler;
            _errorHandler   = asyncDef.errorHandler;
            _finallyHandler = asyncDef.finallyHandler;
            _serialTasks    = asyncDef.serialTasks;
            _parallelTasks  = asyncDef.parallelTasks;
        }

        //----------------------------------------------------------------------
        // task runner
        //----------------------------------------------------------------------

        private function _kickNextSerialTask():void {
            if (_serialTaskIndex >= _serialTasks.length) {
                _onResolve();
                return;
            }

            var nextTask:Async = _serialTasks[_serialTaskIndex];
            ++_serialTaskIndex;

            nextTask.go(function(async:Async):void {
                if (async.state == Async.RESOLVED) {
                    _kickNextSerialTask();
                } else {
                    _onReject();
                }
            });
        }

        private function _kickParallelTasks():void {
            var doneCount:int = 0;

            for each (var task:Async in _parallelTasks) {
                task.go(function(async:Async):void {
                    if (async.state == Async.RESOLVED) {
                        ++doneCount;
                        if (doneCount == _parallelTasks.length) {
                            _onResolve();
                        }
                    } else {
                        _onReject();
                    }
                });
            }
        }

        //----------------------------------------------------------------------
        // result handler
        //----------------------------------------------------------------------

        private function _onResolve():void {
            if (_isResolved) { return; }
            _isResolved = true;

            if (_successHandler != null) {
                _successHandler();
            }
            done();
        }

        private function _onReject():void {
            if (_isRejected) { return; }
            _isRejected = true;

            if (_errorHandler != null) {
                _errorHandler();
            }
            fail();
        }

        private function _finalize():void {
            if (_isFinalized) { return; }
            _isFinalized = true;

            if (_finallyHandler != null) {
                _finallyHandler();
            }
            if (_onComplete != null) {
                _onComplete(this);
            }
        }

    }
}
