package tests {

    import org.hamcrest.assertThat;
    import org.hamcrest.object.equalTo;

    public class SampleTests {

        [Test(description = "Tests addition")]
        public function simpleAdd():void {
            var x:int = 5 + 3;
            assertThat(x, equalTo(8));
        }
    }
}
