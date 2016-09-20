package tests.dessert_knife.tools.signal {

    import org.hamcrest.assertThat;
    import org.hamcrest.core.not;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;

    import dessert_knife.tools.signal.Signal;

    public class SignalTests {

        private function _testNoError(task:Function):void {
            assertThat(task, not(throws(instanceOf(Error))));
        }

        [Test]
        public function basicUsage():void {
            var signal:Signal = new Signal();
            var seq:String = '';

            var fn:Function = function():void { seq += 'a'; };
            signal.connect(fn);

            signal.emit();
            assertThat(seq, equalTo('a'));

            signal.emit();
            assertThat(seq, equalTo('aa'));

            signal.disconnect(fn);
            signal.emit();
            assertThat(seq, equalTo('aa'));
        }

        [Test]
        public function connect_multiArgs():void {
            var signal:Signal = new Signal();
            var seq:String = '';

            var fn1:Function = function(arg1:*                ):void { seq += ':1' + arg1; };
            var fn2:Function = function(arg1:*, arg2:*        ):void { seq += ':2' + arg1 + arg2; };
            var fn3:Function = function(arg1:*, arg2:*, arg3:*):void { seq += ':3' + arg1 + arg2 + arg3; };
            signal.connect(fn1);
            signal.connect(fn2);
            signal.connect(fn3);

            signal.emit('a', 'b', 'c');
            assertThat(seq, equalTo(':1a:2ab:3abc'));
        }

        [Test]
        public function disconnect():void {
            var signal:Signal = new Signal();
            var seq:String = '';

            var fn_a:Function = function(arg:int):void { seq += ':a' + arg; };
            var fn_b:Function = function(arg:int):void { seq += ':b' + arg; };
            var fn_c:Function = function(arg:int):void { seq += ':c' + arg; };
            signal.connect(fn_a);
            signal.connect(fn_b);
            signal.connect(fn_c);
            assertThat(signal.numListeners(), equalTo(3));

            signal.disconnect(fn_b);
            assertThat(signal.numListeners(), equalTo(2));

            signal.emit(3);
            assertThat(seq, equalTo(':a3:c3'));

            // multiple disconnect
            _testNoError(function():void {
                signal.disconnect(fn_b);
            });
            signal.disconnect(fn_a);
            assertThat(signal.numListeners(), equalTo(1));

            signal.emit(5);
            assertThat(seq, equalTo(':a3:c3:c5'));

            signal.disconnect(fn_c);
            assertThat(signal.numListeners(), equalTo(0));

            signal.emit(5);
            assertThat(seq, equalTo(':a3:c3:c5'));
        }

        [Test]
        public function connectOnce():void {
            var signal:Signal = new Signal();
            var seq:String = '';

            var fn_a:Function = function(arg:int):void { seq += ':a' + arg; };
            var fn_b:Function = function(arg:int):void { seq += ':b' + arg; };
            var fn_c:Function = function(arg:int):void { seq += ':c' + arg; };
            signal.connect    (fn_a);
            signal.connectOnce(fn_b);
            signal.connect    (fn_c);

            signal.emit(1);
            assertThat(seq, equalTo(':a1:b1:c1'));
            assertThat(signal.numListeners(), equalTo(2));

            signal.emit(2);
            assertThat(seq, equalTo(':a1:b1:c1:a2:c2'));
        }

        [Test]
        public function disconnectAll():void {
            var signal:Signal = new Signal();
            var seq:String = '';

            var fn_a:Function = function(arg:int):void { seq += ':a' + arg; };
            var fn_b:Function = function(arg:int):void { seq += ':b' + arg; };
            var fn_c:Function = function(arg:int):void { seq += ':c' + arg; };
            signal.connect(fn_a);
            signal.connect(fn_b);
            signal.connectOnce(fn_c);

            signal.disconnectAll();
            assertThat(signal.numListeners(), equalTo(0));
            signal.emit(4);
            assertThat(seq, equalTo(''));
        }

    }
}
