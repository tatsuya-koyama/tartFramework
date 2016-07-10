package tests.dessert_knife {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    import dessert_knife.knife;
    import dessert_knife.tools.async.Await;
    import dessert_knife.tools.async.Async;
    import dessert_knife.tools.async.Promise;

    public class KnifeTests {

        //----------------------------------------------------------------------
        // knife.async()
        //----------------------------------------------------------------------

        [Test]
        public function async():void {
            var trail:Array = [];
            var onTickHandlers:Array = [];

            /**
             *             |3 -------->|
             *             |           |
             *   1 -> 2 -> |4 --->.....| -> anyway
             */
            knife.async({
                serial: [
                    function(async:Async):void {
                        trail.push("1");  async.done();
                    },
                    function(async:Async):void {
                        trail.push("2");  async.done();
                    },
                    {parallel: [
                        function(async:Async):void {
                            onTickHandlers.push(function(count:int):void {
                                if (count == 9) { trail.push("[3]");  async.done(); }
                            });
                        },
                        function(async:Async):void {
                            onTickHandlers.push(function(count:int):void {
                                if (count == 5) { trail.push("[4]");  async.done(); }
                            });
                        }
                    ]}
                ],
                anyway: function():void {
                    trail.push("a");
                }
            }, function():void {
                trail.push("!!!");
            });

            for (var i:int = 0;  i < 10;  ++i) {
                for each (var handler:Function in onTickHandlers) {
                    handler(i);
                }
            }

            assertThat("12[4][3]a!!!", equalTo(trail.join('')));
        }

        //----------------------------------------------------------------------
        // knife.async()
        //----------------------------------------------------------------------

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
        public function await():void {
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
        public function await_callbackArgs():void {
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

        //----------------------------------------------------------------------
        // knife.promise()
        //----------------------------------------------------------------------

        [Test]
        public function promise_doneAtOnce():void {
            var seq:String = '';
            var doit:Function = function():Promise {
                seq += '1';
                return knife.deferred().done().promise;
            };
            doit().then(function():void {
                seq += '2';
            });

            assertThat(seq, equalTo('12'));
        }

        [Test]
        public function promise_failAtOnce():void {
            var seq:String = '';
            var doit:Function = function():Promise {
                seq += '1';
                return knife.deferred().fail().promise;
            };
            doit().otherwise(function():void {
                seq += '2';
            });

            assertThat(seq, equalTo('12'));
        }

    }
}
