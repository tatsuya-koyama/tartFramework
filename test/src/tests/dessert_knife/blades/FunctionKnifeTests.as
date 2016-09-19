package tests.dessert_knife.blades {

    import org.hamcrest.assertThat;
    import org.hamcrest.core.allOf;
    import org.hamcrest.core.not;
    import org.hamcrest.core.throws;
    import org.hamcrest.number.closeTo;
    import org.hamcrest.number.lessThan;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;

    import dessert_knife.knife;
    import dessert_knife.blades.FunctionKnife;

    public class FunctionKnifeTests {

        private function _testArgError(task:Function):void {
            assertThat(task, throws(instanceOf(ArgumentError)));
        }

        private function _testNotArgError(task:Function):void {
            assertThat(task, not(throws(instanceOf(ArgumentError))));
        }

        [Test]
        public function safeCall_arg1():void {
            var handler1:Function = function(arg1:int):void { return; };

            _testArgError(function():void { handler1(); });
            _testArgError(function():void { handler1(1, 2); });

            _testNotArgError(function():void { knife.func.safeCall(handler1); });
            _testNotArgError(function():void { knife.func.safeCall(handler1, 1); });
            _testNotArgError(function():void { knife.func.safeCall(handler1, 1, 2); });
            _testNotArgError(function():void { knife.func.safeCall(handler1, 1, 2 ,3); });
            _testNotArgError(function():void { knife.func.safeCall(handler1, 1 ,2 ,3, 4); });
        }

        [Test]
        public function safeCall_arg2():void {
            var handler2:Function = function(arg1:int, arg2:int):void { return; };

            _testArgError(function():void { handler2(); });
            _testArgError(function():void { handler2(1); });
            _testArgError(function():void { handler2(1, 2, 3); });

            _testNotArgError(function():void { knife.func.safeCall(handler2); });
            _testNotArgError(function():void { knife.func.safeCall(handler2, 1); });
            _testNotArgError(function():void { knife.func.safeCall(handler2, 1, 2); });
            _testNotArgError(function():void { knife.func.safeCall(handler2, 1, 2 ,3); });
            _testNotArgError(function():void { knife.func.safeCall(handler2, 1 ,2 ,3, 4); });
        }

    }
}
