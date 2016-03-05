package tests.dessert_knife.tools.async {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    import dessert_knife.tools.async.Defer;

    import flash.utils.setTimeout;

    public class DeferTests {

        private function _virtualAsync():Object {
            return {
                _task: null,
                set: function(task:Function):void {
                    this._task = task;
                },
                exec: function():void {
                    this._task();
                }
            };
        }

        [Test]
        public function basic_1():void {
            var async:Object = _virtualAsync();
            var seq:String = '';

            var deferredTask:Function = function():Defer {
                var defer:Defer = new Defer();
                async.set(function():void {
                    defer.done('3');
                });
                return defer;
            };

            seq += '1';
            deferredTask()
                .then(function(result:String):void {
                    seq += result;
                    assertThat(seq, equalTo('123'));
                });
            seq += '2';

            async.exec();
        }

        [Test]
        public function basic_2():void {
            var async:Object = _virtualAsync();
            var seq:String = '';

            var deferredTask:Function = function():Defer {
                var defer:Defer = new Defer();
                async.set(function():void {
                    defer.done('3');
                });
                return defer;
            };

            seq += '1';
            deferredTask()
                .then(function(result:String):String {
                    seq += result;
                    return '4';
                })
                .then(function(result:String):void {
                    seq += result;
                    assertThat(seq, equalTo('1234'));
                });
            seq += '2';

            async.exec();
        }

        [Test]
        public function exec_order():void {
            var async:Object = _virtualAsync();
            var result:int = 0;

            var deferredTask:Function = function():Defer {
                var defer:Defer = new Defer();
                async.set(function():void {
                    defer.done(10);
                });
                return defer;
            };

            deferredTask()
                .then(function(result:int):int { return result * 2; })   // 20
                .then(function(result:int):int { return result + 5; })   // 25
                .then(function(result:int):int { return result % 10; })  // 5
                .then(function(result:int):void {
                    assertThat(result, equalTo(5));
                });

            async.exec();
        }

        [Test]
        public function return_at_once_1():void {
            var seq:String = '';

            var deferredTask:Function = function():Defer {
                var defer:Defer = new Defer();
                return defer.done('2');
            };

            seq += '1';
            deferredTask()
                .then(function(result:String):void {
                    seq += result;
                    assertThat(seq, equalTo('12'));
                });
            seq += '3';
        }

        [Test]
        public function defer_in_then():void {
            var seq:String = '';

            // task A
            var asyncA:Object = _virtualAsync();
            var appendA:Function = function(input:String):Defer {
                var defer:Defer = new Defer();
                asyncA.set(function():void {
                    defer.done(input + 'A');
                });
                return defer;
            };

            // task B
            var asyncB:Object = _virtualAsync();
            var appendB:Function = function(input:String):Defer {
                var defer:Defer = new Defer();
                asyncB.set(function():void {
                    defer.done(input + 'B');
                });
                return defer;
            };

            seq += '1';
            appendA('-')
                .then(function(result:String):String { seq += result; return result; })
                .then(appendB)
                .then(function(result:String):void { seq += result; });

            seq += '2';
            assertThat(seq, equalTo('12'));

            asyncA.exec();
            assertThat(seq, equalTo('12-A'));

            asyncB.exec();
            assertThat(seq, equalTo('12-A-AB'));
        }

        [Test]
        public function defer_in_then_2():void {
            var seq:String = '';

            var defer:Defer = new Defer();
            defer.done()
                .then(function():Defer {
                    var defer2:Defer = new Defer();
                    setTimeout(function():void {
                        seq += '1';
                        defer2.done();
                    }, 0);
                    return defer2;
                })
                .then(function():void {
                    seq += '2';
                })
                .then(function():void {
                    assertThat(seq, equalTo('12'));
                });
        }

    }
}
