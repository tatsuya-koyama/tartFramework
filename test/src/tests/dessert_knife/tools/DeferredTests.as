package tests.dessert_knife.tools {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    import dessert_knife.tools.Deferred;
    import dessert_knife.tools.Promise;

    import flash.utils.setTimeout;

    public class DeferredTests {

        [Test]
        public function resolve():void {
            var seq:String = '';
            var deferredTask:Function = function():Promise {
                var defer:Deferred = new Deferred(true);

                setTimeout(function():void {
                    defer.done('3');
                }, 0);
                return defer.promise;
            };

            seq += '1';
            deferredTask()
                .then(function(result:String):void {
                    seq += result;
                    assertThat(seq, equalTo('123'));
                });
            seq += '2';
        }

        [Test]
        public function resolve_at_once():void {
            var seq:String = '';
            var deferredTask:Function = function():Promise {
                var defer:Deferred = new Deferred(true);
                return defer.done('3').promise;
            };

            seq += '1';
            deferredTask()
                .then(function(result:String):void {
                    seq += result;
                    assertThat(seq, equalTo('123'));
                });
            seq += '2';
        }

        [Test]
        public function reject():void {
            var seq:String = '';
            var deferredTask:Function = function():Promise {
                var defer:Deferred = new Deferred(true);

                setTimeout(function():void {
                    defer.fail('E');
                }, 0);
                return defer.promise;
            };

            seq += '1';
            deferredTask()
                .otherwise(function(error:String):void {
                    seq += error;
                    assertThat(seq, equalTo('12E'));
                });
            seq += '2';
        }

    }
}
