package tests.dessert_knife.blades {

    import org.hamcrest.assertThat;
    import org.hamcrest.core.allOf;
    import org.hamcrest.number.closeTo;
    import org.hamcrest.number.lessThan;
    import org.hamcrest.object.equalTo;

    import dessert_knife.knife;
    import dessert_knife.blades.RandomKnife;
    import dessert_knife.tools.random.DebugRandomizer;

    public class RandomKnifeTests {

        private const LIMIT_1:Number = 1 - 1.0e-10;
        private const EPSILON:Number = 0.001;

        [Test]
        public function integer_0arg():void {
            var randomizer:DebugRandomizer = new DebugRandomizer();
            var rand:RandomKnife = knife.rand.seeded(0, randomizer);

            randomizer.nextValue = 0.0;
            assertThat(rand.integer(), equalTo(0));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.integer(), equalTo(int.MAX_VALUE));

            randomizer.nextValue = 0.5;
            assertThat(rand.integer(), equalTo(Math.round(int.MAX_VALUE / 2)));
        }

        [Test]
        public function integer_1arg():void {
            var randomizer:DebugRandomizer = new DebugRandomizer();
            var rand:RandomKnife = knife.rand.seeded(0, randomizer);

            //----- [0, 100]
            randomizer.nextValue = 0.0;
            assertThat(rand.integer(100), equalTo(0));

            randomizer.nextValue = 0.35;
            assertThat(rand.integer(100), equalTo(35));

            randomizer.nextValue = 0.63;
            assertThat(rand.integer(100), equalTo(63));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.integer(100), equalTo(100));

            //----- [-100, 0]
            randomizer.nextValue = 0.0;
            assertThat(rand.integer(-100), equalTo(-100));

            randomizer.nextValue = 0.45;
            assertThat(rand.integer(-100), equalTo(-55));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.integer(-100), equalTo(0));
        }

        [Test]
        public function integer_2args():void {
            var randomizer:DebugRandomizer = new DebugRandomizer();
            var rand:RandomKnife = knife.rand.seeded(0, randomizer);

            //----- [5, 15]
            randomizer.nextValue = 0.0;
            assertThat(rand.integer(5, 15), equalTo(5));

            randomizer.nextValue = 0.3;
            assertThat(rand.integer(5, 15), equalTo(8));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.integer(5, 15), equalTo(15));

            //----- [5, 15] with swapping args
            randomizer.nextValue = 0.0;
            assertThat(rand.integer(15, 5), equalTo(5));

            randomizer.nextValue = 0.3;
            assertThat(rand.integer(15, 5), equalTo(8));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.integer(15, 5), equalTo(15));

            //----- [-10, 30]
            randomizer.nextValue = 0.0;
            assertThat(rand.integer(-10, 30), equalTo(-10));

            randomizer.nextValue = 0.5;
            assertThat(rand.integer(-10, 30), equalTo(10));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.integer(-10, 30), equalTo(30));
        }

        [Test]
        public function float_0arg():void {
            var randomizer:DebugRandomizer = new DebugRandomizer();
            var rand:RandomKnife = knife.rand.seeded(0, randomizer);

            randomizer.nextValue = 0.0;
            assertThat(rand.float(), closeTo(0, EPSILON));

            randomizer.nextValue = 0.5;
            assertThat(rand.float(), closeTo(Number.MAX_VALUE / 2, EPSILON));

            // * Cannot seem to handle large number by closeTo().
            // randomizer.nextValue = LIMIT_1;
            // assertThat(rand.float(), closeTo(Number.MAX_VALUE, EPSILON));
        }

        [Test]
        public function float_1arg():void {
            var randomizer:DebugRandomizer = new DebugRandomizer();
            var rand:RandomKnife = knife.rand.seeded(0, randomizer);

            //----- [0, 100)
            randomizer.nextValue = 0.0;
            assertThat(rand.float(100), closeTo(0, EPSILON));

            randomizer.nextValue = 0.48;
            assertThat(rand.float(100), closeTo(48, EPSILON));

            randomizer.nextValue = 0.72;
            assertThat(rand.float(100), closeTo(72, EPSILON));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.float(100), allOf(
                closeTo(100, EPSILON), lessThan(100)
            ));

            //----- [-100, 0)
            randomizer.nextValue = 0.0;
            assertThat(rand.float(-100), closeTo(-100, EPSILON));

            randomizer.nextValue = 0.30;
            assertThat(rand.float(-100), closeTo(-70, EPSILON));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.float(-100), allOf(
                closeTo(0, EPSILON), lessThan(0)
            ));
        }

        [Test]
        public function float_2args():void {
            var randomizer:DebugRandomizer = new DebugRandomizer();
            var rand:RandomKnife = knife.rand.seeded(0, randomizer);

            //----- [3, 13)
            randomizer.nextValue = 0.0;
            assertThat(rand.float(3, 13), closeTo(3, EPSILON));

            randomizer.nextValue = 0.3;
            assertThat(rand.float(3, 13), closeTo(6, EPSILON));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.float(3, 13), allOf(
                closeTo(13, EPSILON), lessThan(13)
            ));

            //----- [3, 13) with swapping args
            randomizer.nextValue = 0.0;
            assertThat(rand.float(13, 3), closeTo(3, EPSILON));

            randomizer.nextValue = 0.3;
            assertThat(rand.float(13, 3), closeTo(6, EPSILON));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.float(13, 3), allOf(
                closeTo(13, EPSILON), lessThan(13)
            ));

            //----- [-15, 25)
            randomizer.nextValue = 0.0;
            assertThat(rand.float(-15, 25), closeTo(-15, EPSILON));

            randomizer.nextValue = 0.5;
            assertThat(rand.float(-15, 25), closeTo(5, EPSILON));

            randomizer.nextValue = LIMIT_1;
            assertThat(rand.float(-15, 25), allOf(
                closeTo(25, EPSILON), lessThan(25)
            ));
        }

    }
}
