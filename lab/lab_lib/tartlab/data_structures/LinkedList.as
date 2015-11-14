package tartlab.data_structures {

    public class LinkedList {

        private var _head:LinkedListNode;
        private var _tail:LinkedListNode;
        private var _size:int;

        public function LinkedList() {
            _head = null;
            _tail = null;
            _size = 0;
        }

        public function get head():LinkedListNode {
            return _head;
        }

        public function get tail():LinkedListNode {
            return _tail;
        }

        public function get size():int {
            return _size;
        }

        public function removeAll():void {
            _head = null;
            _tail = null;
            _size = 0;
        }

        // add node to tail of list
        public function push(item:*):void {
            if (_size == 0) {
                var node:LinkedListNode = new LinkedListNode(item);
                node.prev = node.next = null;
                _head = _tail = node;
                ++_size;
                return;
            }

            _tail = _tail.addAfter(item);
            ++_size;
        }

        // ToDo:
        //   pop, shift, unshift, and remove / dispose methods

        public function iterator():LinkedListIterator {
            return new LinkedListIterator(this);
        }

    }
}
