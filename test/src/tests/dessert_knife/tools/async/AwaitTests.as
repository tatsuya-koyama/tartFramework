package tests.dessert_knife.tools.async {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Await;

    public class AwaitTests {

        private function _makeTicker():Object {
            return {
                _frame   : 0,
                _handlers: [],

                add: function(handler:Function):void {
                    this._handlers.push(handler);
                },

                tick: function(times:int):void {
                    for (var i:int = 0; i < times; ++i) {
                        ++this._frame;
                        for each (var handler:Function in this._handlers) {
                            handler(this._frame);
                        }
                    }
                }
            };
        }

        [Test]
        public function basic():void {
            var ticker:Object = _makeTicker();

            var callAt:Function = function(targetFrame:int, callback:Function):void {
                ticker.add(function(frame:int):void {
                    if (frame == targetFrame) { callback(); }
                });
            };

            var sequence:String = '';
            Await.doit(
                function(await:Await):void {
                    sequence += '_wait7';
                    callAt(7, await.it());

                    sequence += '_wait3';
                    callAt(3, await.it());

                    sequence += '_wait5';
                    callAt(5, await.it());
                },
                function():void {
                    sequence += '_finishAll';
                }
            );

            sequence += '_tick5';
            ticker.tick(5);

            sequence += '_tick2';
            ticker.tick(2);

            assertThat(sequence, equalTo("_wait7_wait3_wait5_tick5_tick2_finishAll"));
        }

        [Test]
        public function from_knife():void {
            var ticker:Object = _makeTicker();

            var callAt:Function = function(targetFrame:int, callback:Function):void {
                ticker.add(function(frame:int):void {
                    if (frame == targetFrame) { callback(); }
                });
            };

            var sequence:String = '';
            knife.await(
                function(await:Await):void {
                    sequence += '_wait4';
                    callAt(4, await.it());

                    sequence += '_wait8';
                    callAt(8, await.it());
                },
                function():void {
                    sequence += '_finishAll';
                }
            );

            sequence += '_tick6';
            ticker.tick(6);

            sequence += '_tick2';
            ticker.tick(2);

            assertThat(sequence, equalTo("_wait4_wait8_tick6_tick2_finishAll"));
        }

        [Test]
        public function callbackArgs():void {
            var caller:Function = function(param1:int, param2:int, onComplete:Function):void {
                onComplete(param1, param2);
            };

            var sequence:String = '';
            knife.await(
                function(await:Await):void {
                    caller(1, 2, await.it(
                        function(param1:int, param2:int):void {
                            sequence += param1 + "-" + param2;
                        }
                    ));
                },
                function():void {
                    sequence += '_finish';
                }
            );

            assertThat(sequence, equalTo("1-2_finish"));
        }

    }
}
