package tests.dessert_knife.tools.signal {

    import org.hamcrest.assertThat;
    import org.hamcrest.core.not;
    import org.hamcrest.core.throws;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;

    import dessert_knife.tools.signal.MessageChannel;

    public class MessageChannelTests {

        private function _testNoError(task:Function):void {
            assertThat(task, not(throws(instanceOf(Error))));
        }

        [Test]
        public function basicUsage():void {
            var channel:MessageChannel = new MessageChannel();
            var seq:String = '';

            var listener_1 :Function = function(arg:*):void { seq += '1:' + arg; };
            var listener_2 :Function = function(arg:*):void { seq += '2:' + arg; };
            var listener_3A:Function = function(arg:*):void { seq += 'A:' + arg; };
            var listener_3B:Function = function(arg:*):void { seq += 'B:' + arg; };

            channel.subscribe('Message_1', listener_1);
            channel.subscribe('Message_2', listener_2);
            channel.subscribe(3000,        listener_3A);
            channel.subscribe(3000,        listener_3B);

            channel.publish('Message_2', 'a');
            assertThat(seq, equalTo('2:a'));

            channel.publish(3000, 'b');
            assertThat(seq, equalTo('2:aA:bB:b'));
        }

        [Test]
        public function usage_2():void {
            var channel:MessageChannel = new MessageChannel();
            var seq:String = '';

            var listener_A:Function = function(arg:*):void { seq += 'A:' + arg; };
            var listener_B:Function = function(arg:*):void { seq += 'B:' + arg; };
            var listener_C:Function = function(arg1:*, arg2:*):void { seq += 'C:' + arg1 + arg2; };

            channel.subscribe(3, listener_A);
            channel.subscribe(3, listener_B);
            channel.subscribe(4, listener_C);

            // Publishing unsubscribed message causes no error.
            _testNoError(function():void {
                channel.publish(5);
            });
            assertThat(seq, equalTo(''));

            // No arguments gives null to listeners.
            channel.publish(4);
            assertThat(seq, equalTo('C:nullnull'));
        }

        [Test]
        public function unsubscribe():void {
            var channel:MessageChannel = new MessageChannel();
            var seq:String = '';

            var listener_1:Function = function(arg:*):void { seq += '1:' + arg; };
            var listener_2:Function = function(arg:*):void { seq += '2:' + arg; };
            var listener_3:Function = function(arg:*):void { seq += '3:' + arg; };

            channel.subscribe('10', listener_1);
            channel.subscribe('20', listener_2);
            channel.subscribe('30', listener_3);

            channel.publish('20', 'a');
            channel.publish('30', 'a');
            assertThat(seq, equalTo('2:a3:a'));

            // Not subscribed message
            _testNoError(function():void {
                channel.unsubscribe('--', listener_1);
            });

            // Not subscribing listener
            _testNoError(function():void {
                channel.unsubscribe('10', listener_2);
            });

            channel.unsubscribe('20', listener_2);
            channel.publish('20', 'b');
            channel.publish('30', 'b');
            assertThat(seq, equalTo('2:a3:a3:b'));
        }

        [Test]
        public function subscribeOnce():void {
            var channel:MessageChannel = new MessageChannel();
            var seq:String = '';

            var listener_1:Function = function(arg:*):void { seq += '1:' + arg; };
            var listener_2:Function = function(arg:*):void { seq += '2:' + arg; };
            var listener_3:Function = function(arg:*):void { seq += '3:' + arg; };

            channel.subscribe    ('100', listener_1);
            channel.subscribe    ('200', listener_2);
            channel.subscribeOnce('100', listener_3);

            channel.publish('100', 'a');
            assertThat(seq, equalTo('1:a3:a'));

            // listener_3 unsubscribed '100'
            channel.publish('100', 'b');
            assertThat(seq, equalTo('1:a3:a1:b'));
        }

    }
}
