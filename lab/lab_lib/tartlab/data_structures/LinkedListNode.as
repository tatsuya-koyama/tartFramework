package tartlab.data_structures {

    public class LinkedListNode {

        public var prev:LinkedListNode = null;
        public var next:LinkedListNode = null;
        public var item:* = null;

        public function LinkedListNode(item:*) {
            this.item = item;
        }

        public function addAfter(item:*):LinkedListNode {
            var node:LinkedListNode = new LinkedListNode(item);
            node.next = this.next;
            this.next = node;
            node.prev = this;
            return node;
        }

    }
}
