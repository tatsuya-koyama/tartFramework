package dessert_knife.tools.random {

    public interface IRandomizer {

        // Returns floating random number in the range [0, 1).
        function random():Number;

        // Set seed to generate reproducible random number.
        function setSeed(seed:uint):void;

    }
}
