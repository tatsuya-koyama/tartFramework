package tests.data_structures {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    import tartlab.data_structures.IIterator;
    import tartlab.data_structures.LinkedList;

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
            var actual:String = '';
            for (var item:* = _iter.head(); item; item = _iter.next()) {
                actual += item;
            }
            assertThat(actual, '3.14');
        }

        [Test]
        public function insert_in_the_middle_of_iteration():void {
            _list.removeAll();
            for (var i:int = 1; i <= 9; ++i) {
                _list.push(i);
            }

            // insert
            var item:*;
            for (item = _iter.head(); item; item = _iter.next()) {
                if (int(item) % 3 == 0) {
                    _iter.addAfter('a');
                }
            }

            // iteration
            var actual:String = '';
            for (item = _iter.head(); item; item = _iter.next()) {
                actual += item;
            }
            assertThat(actual, '123a456a789a');
        }

    }
}
