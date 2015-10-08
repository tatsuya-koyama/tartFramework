package tart.data_structures {

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
            // ToDo: ちゃんと参照切る？
            _head = null;
            _tail = null;
            _size = 0;
        }

        // add to tail
        // ToDo: priority option
        public function push(item:*):void {
            var node:LinkedListNode = new LinkedListNode(item);

            if (_size == 0) {
                node.prev = node.next = null;
                _head = _tail = node;
                ++_size;
                return;
            }

            var oldTail:LinkedListNode = _tail;
            _tail.next = node;
            node.prev  = _tail;
            node.next  = null;
            _tail      = node;
            ++_size;
        }

        // ToDo:
        //   pop, shift, unshift, and remove / dispose methods

        public function iterator():LinkedListIterator {
            return new LinkedListIterator(this);
        }

    }
}
