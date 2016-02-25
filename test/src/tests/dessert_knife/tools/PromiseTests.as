package tests.dessert_knife.tools {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    import dessert_knife.tools.Promise;

    public class PromiseTests {

        [Test]
        public function resolve_1():void {
            var seq:String = '';
            var promise:Promise = new Promise(function(resolve:Function, reject:Function):void {
                seq += '1';
                resolve('4');
            }, true);
            seq += '2';

            promise
                .then(function(result:String):void {
                    seq += result;
                })
                .then(function(result:String):void {
                    seq += '5';
                    assertThat(seq, equalTo('12345'));
                });
            seq += '3';
        }

        [Test]
        public function reject_1():void {
            var seq:String = '';
            var promise:Promise = new Promise(function(resolve:Function, reject:Function):void {
                seq += '1';
                reject('E');
            }, true);
            seq += '2';

            promise.then(
                function(result:String):void {
                    seq += 'SUCCESS';
                },
                function(error:String):void {
                    seq += error;
                    assertThat(seq, equalTo('123E'));
                }
            );
            seq += '3';
        }

        [Test]
        public function reject_2():void {
            var seq:String = '';
            var promise:Promise = new Promise(function(resolve:Function, reject:Function):void {
                seq += '1';
                reject('E')
            }, true);
            seq += '2';

            promise
                .then(function():void { seq += '4'; })  // passed
                .then(function():void { seq += '5'; })  // passed
                .then(null, function(error:String):void {  // catch!
                    seq += error;
                    assertThat(seq, equalTo('123E'));
                })
            seq += '3';
        }

        [Test]
        public function reject_3():void {
            var seq:String = '';
            var promise:Promise = new Promise(function(resolve:Function, reject:Function):void {
                seq += '1';
                reject('EA')
            }, true);
            seq += '2';

            promise
                .then(function():void { seq += '4'; })  // passed
                .then(function():void { seq += '5'; })  // passed
                .then(null, function(error:String):void { seq += error; })
                .then(function():void { seq += '6'; })
                .then(function():void { seq += '7'; })
                .then(function():Promise {
                    return new Promise(function(resolve:Function, reject:Function):void {
                        reject('EB');
                    });
                })
                .then(function():void { seq += '8'; })  // passed
                .then(function():void { seq += '9'; })  // passed
                .then(null, function(error:String):void {
                    seq += error;
                    assertThat(seq, equalTo('123EA67EB'));
                });
            seq += '3';
        }

        [Test]
        public function otherwise_1():void {
            var seq:String = '';
            var promise:Promise = new Promise(function(resolve:Function, reject:Function):void {
                seq += '1';
                reject('E');
            }, true);
            seq += '2';

            promise
                .then(function(result:String):void { seq += 'SUCCESS'; })
                .otherwise(function(error:String):void {
                    seq += error;
                    assertThat(seq, equalTo('123E'));
                });
            seq += '3';
        }

        [Test]
        public function otherwise_2():void {
            var seq:String = '';
            var promise:Promise = new Promise(function(resolve:Function, reject:Function):void {
                seq += '1';
                reject('EA')
            }, true);
            seq += '2';

            promise
                .then(function():void { seq += '4'; })  // passed
                .then(function():void { seq += '5'; })  // passed
                .otherwise(function(error:String):void { seq += error; })
                .then(function():void { seq += '6'; })
                .then(function():void { seq += '7'; })
                .then(function():Promise {
                    return new Promise(function(resolve:Function, reject:Function):void {
                        reject('EB');
                    });
                })
                .then(function():void { seq += '8'; })  // passed
                .then(function():void { seq += '9'; })  // passed
                .otherwise(function(error:String):void {
                    seq += error;
                    assertThat(seq, equalTo('123EA67EB'));
                });
            seq += '3';
        }

        [Test]
        public function mix_up_1():void {
            var asyncTask:Function = function(data:int):Promise {
                return new Promise(function(resolve:Function, reject:Function):void {
                    resolve(data);
                });
            };
            var increment:Function = function(data:int):int {
                return data + 1;
            };
            var asyncIncrement:Function = function(data:int):Promise {
                return new Promise(function(resolve:Function, reject:Function):void {
                    resolve(data + 1);
                });
            };
            var asyncDoubleUp:Function = function(data:int):Promise {
                return new Promise(function(resolve:Function, reject:Function):void {
                    resolve(data * 2);
                });
            };
            var rejectCommand:Function = function(data:int):Promise {
                return new Promise(function(resolve:Function, reject:Function):void {
                    reject(data - 50);
                });
            };

            asyncTask(100)
                .then(asyncIncrement)  // 101
                .then(increment)       // 102
                .then(asyncDoubleUp)   // 204
                .then(asyncDoubleUp)   // 408
                .then(function(result:int):int {
                    assertThat(result, equalTo(408));
                    return result;
                })
                .then(rejectCommand)   // 358
                .then(increment)       // passed
                .then(asyncDoubleUp)   // passed
                .otherwise(function(result:int):void {
                    assertThat(result, equalTo(358));
                });
        }

        [Test]
        public function syntax_sugar_1():void {
            var seq:String = '';
            Promise.resolve('2', true)
                .then(function(result:String):void {
                    seq += result;
                    assertThat(seq, equalTo('12'));
                });
            seq += '1';
        }

        [Test]
        public function syntax_sugar_2():void {
            var seq:String = '';
            Promise.reject('2', true)
                .otherwise(function(result:String):void {
                    seq += result;
                    assertThat(seq, equalTo('12'));
                });
            seq += '1';
        }

        [Test]
        public function parallel_then_1():void {
            var promise:Promise = new Promise(function(resolve:Function, reject:Function):void {
                resolve(100);
            }, true);

            var result:int = 0;
            promise.then(function(data:int):int { result += data + 1; return data * 2; })
            promise.then(function(data:int):int { result += data + 3; return data * 2; })
            promise.then(function(data:int):int { result += data + 7; return data * 2; })
                .then(function():void {
                    assertThat(result, equalTo(311));
                });
        }

    }
}
