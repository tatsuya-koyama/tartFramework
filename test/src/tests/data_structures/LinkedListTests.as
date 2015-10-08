package tests.data_structures {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    import tart.data_structures.IIterator;
    import tart.data_structures.LinkedList;

    public class LinkedListTests {

        private var _list:LinkedList;
        private var _iter:IIterator;

        [Before]
        public function makeList():void {
            _list = new LinkedList();
            _iter = _list.iterator();
        }

        [Test]
        public function getSize():void {
            _list.removeAll();
            _list.push(1);
            _list.push(2);
            _list.push(3);

            // get size of list
            assertThat(_list.size, equalTo(3));
        }

        [Test]
        public function iterate():void {
            _list.removeAll();
            _list.push(3);
            _list.push('.');
            _list.push(1);
            _list.push(4);

            // iteration
            var actual_1:String = '';
            for (var item:* = _iter.head(); item; item = _iter.next()) {
                actual_1 += item;
            }
            assertThat(actual_1, '3.14');
        }

    }
}
