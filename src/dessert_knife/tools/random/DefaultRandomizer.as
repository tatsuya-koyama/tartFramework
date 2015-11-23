package dessert_knife.tools.random {

    public class DefaultRandomizer implements IRandomizer {

        public function random():Number {
            return Math.random();
        }

        public function setSeed(seed:uint):void {
            // do nothing
        }

    }
}
