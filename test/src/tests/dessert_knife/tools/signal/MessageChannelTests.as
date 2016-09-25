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

    }
}
