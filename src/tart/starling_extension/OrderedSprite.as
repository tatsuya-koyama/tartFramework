package tart.starling_extension {

    import starling.display.Sprite;

    public class OrderedSprite extends Sprite {

        public var zOrder:int = 0;

        public function OrderedSprite(zOrder:int=0) {
            super();
            this.zOrder = zOrder;
        }

    }
}
